# pyright: reportMissingImports=false
# vim:ft=python
"""Solarized Osaka tab bar with cell-aware, bounded rendering.

Layout: [ session ] [ tabs sized by Kitty ] [ keyboard mode / layout ]
"""

from typing import NamedTuple

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, get_options
from kitty.rgb import color_from_int
from kitty.tab_bar import (DrawData, ExtraData, TabBarData,
                           apply_title_template, as_rgb,
                           draw_attributed_string, truncate_line, wcswidth)
from kitty.utils import color_as_int, sgr_sanitizer_pat

SESSION_BG = 0x657B83
ACTIVE_TAB_BG = 0x1A6497
ACTIVE_TAB_FG = 0xB8C1C1
INACTIVE_TAB_BG = 0x063540  # Solarized Osaka: base02.
MODE_FG = 0xADB8B8
MODE_BG = 0xB7221E
NORMAL_MODE_BG = ACTIVE_TAB_BG
STATUS_ACCENT_BG = 0xC94C16  # Solarized Osaka: orange500.
ICON_MODE = '\uf11c'
ICON_LAYOUT = '\uf0db'
MIN_TITLE_CELLS = 8
TAB_SPACING = 1
POWERLINE_ENABLED = True
POWERLINE_SEPARATOR = '\ue0b0'
POWERLINE_SOFT_SEPARATOR = '\ue0b1'
POWERLINE_LEFT_SEPARATOR = '\ue0b2'
POWERLINE_LEFT_SOFT_SEPARATOR = '\ue0b3'


class Segment(NamedTuple):
    """A status segment with unpacked RGB colors."""

    text: str
    foreground: int
    background: int
    bold: bool = False


def cell_width(text: str) -> int:
    """Measure visible terminal cells, excluding SGR color sequences."""
    return max(0, wcswidth(sgr_sanitizer_pat().sub('', text)))


def single_line(text: str) -> str:
    """Keep titles and status labels on the horizontal tab bar."""
    return text.replace('\n', ' ').replace('\r', ' ').replace('\t', ' ')


def fit_text(text: str, width: int) -> str:
    """Clip before drawing, preserving SGR styling and whole graphemes."""
    if width <= 0:
        return ''
    if cell_width(text) <= width:
        return text
    return truncate_line(text, width)


def set_style(
    screen: Screen,
    foreground: int,
    background: int,
    bold: bool = False,
) -> None:
    screen.cursor.fg = as_rgb(foreground)
    screen.cursor.bg = as_rgb(background)
    screen.cursor.bold = bold
    screen.cursor.italic = False


def powerline_status(
    segments: list[Segment], background: int
) -> list[Segment]:
    """Join right-aligned blocks with left-facing Powerline transitions."""
    result: list[Segment] = []
    for segment in segments:
        if background == segment.background:
            separator = Segment(
                POWERLINE_LEFT_SOFT_SEPARATOR,
                segment.foreground,
                background,
            )
        else:
            separator = Segment(
                POWERLINE_LEFT_SEPARATOR, segment.background, background
            )
        result.extend((separator, segment))
        background = segment.background
    return result


def status_segments(
    draw_data: DrawData, tab: TabBarData
) -> tuple[Segment, list[Segment]]:
    """Read status from the tab's OS window, including inactive windows."""
    boss = get_boss()
    manager = boss.os_window_map.get(tab.os_window_id)
    active_tab = manager.active_tab if manager else None
    session = single_line(tab.active_session_name or 'default')
    layout = single_line(
        active_tab.current_layout.name if active_tab else tab.layout_name
    )
    mode = boss.mappings.current_keyboard_mode_name or 'normal'
    mode_display = 'normal' if mode == 'normal' else 'prefix'
    background = int(draw_data.default_bg)
    opts = get_options()

    left = Segment(f' [SESSION: {session}] ', background, SESSION_BG, True)
    right = [
        Segment(
            '' if POWERLINE_ENABLED else ' ',
            background,
            color_as_int(opts.color3),
        ),
        Segment(
            f' {ICON_MODE} {mode_display} ',
            MODE_FG,
            NORMAL_MODE_BG if mode == 'normal' else MODE_BG,
        ),
        Segment(f' {ICON_LAYOUT} {layout} ', ACTIVE_TAB_FG, ACTIVE_TAB_BG),
        Segment(' ', background, color_as_int(opts.color2)),
    ]
    if POWERLINE_ENABLED:
        right.insert(0, Segment('', background, STATUS_ACCENT_BG))
        right = powerline_status(right, background)
    return left, right


def draw_segments(
    screen: Screen, segments: list[Segment], width: int
) -> None:
    """Draw at most width cells, even when the status is abbreviated."""
    end = screen.cursor.x + width
    for segment in segments:
        remaining = end - screen.cursor.x
        if remaining <= 0:
            break
        set_style(
            screen,
            segment.foreground,
            segment.background,
            segment.bold,
        )
        text = fit_text(segment.text, remaining)
        draw_attributed_string(text, screen)
        if cell_width(segment.text) > remaining:
            break
    screen.draw(' ' * max(0, end - screen.cursor.x))


def status_widths(left: int, right: int, budget: int) -> tuple[int, int]:
    """Shrink the side blocks fairly after reserving room for the title."""
    if left + right <= budget:
        return left, right
    left_width = min(left, budget // 2) if right else min(left, budget)
    right_width = min(right, budget - left_width)
    left_width = min(left, budget - right_width)
    # A one-cell status would show only its decorative padding.
    return (
        left_width if left_width > 1 else 0,
        right_width if right_width > 2 else 0,
    )


def tab_label(
    draw_data: DrawData, tab: TabBarData, index: int, width: int
) -> str:
    """Apply Kitty templates and both configured and available limits."""
    prefix = f' {index}: '
    title_width = max(0, width - cell_width(prefix) - 1)
    if draw_data.max_tab_title_length > 0:
        title_width = min(title_width, draw_data.max_tab_title_length)
    title = single_line(
        apply_title_template(draw_data, tab, index, title_width)
    )
    title = fit_text(title, title_width)
    if title_width == 0:
        return fit_text(f' {index}: …', width)
    trailing_space = ' ' if not tab.is_active else ' '
    return fit_text(f'{prefix}{title}{trailing_space}', width)


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    """Measure honestly, then render inside Kitty's allocated tab slot."""
    if tab.is_active:
        # Template directives such as {fmt.fg.tab} use the same colors.
        draw_data = draw_data._replace(
            active_fg=color_from_int(ACTIVE_TAB_FG),
            active_bg=color_from_int(ACTIVE_TAB_BG),
        )
        tab = tab._replace(active_fg=ACTIVE_TAB_FG, active_bg=ACTIVE_TAB_BG)
    else:
        tab = tab._replace(inactive_bg=INACTIVE_TAB_BG)

    width = max(0, min(max_tab_length, screen.columns - before))
    separator = POWERLINE_SEPARATOR if POWERLINE_ENABLED else ''
    separator_width = cell_width(separator)
    next_tab = extra_data.next_tab
    active_edge = tab.is_active or (
        next_tab is not None and next_tab.is_active
    )
    active_leading_edge = (
        next_tab is not None and next_tab.is_active and not tab.is_active
    )
    edge_width = separator_width
    if POWERLINE_ENABLED:
        edge_width += cell_width(POWERLINE_SOFT_SEPARATOR)
    edge_width = edge_width if width > edge_width else 0
    spacing = (
        min(TAB_SPACING, max(0, width - 1))
        if not POWERLINE_ENABLED and not is_last else 0
    )
    content_width = width - spacing - edge_width
    left, right = status_segments(draw_data, tab)
    left_padding = (
        separator_width + cell_width(POWERLINE_SOFT_SEPARATOR)
        if POWERLINE_ENABLED else TAB_SPACING
    )
    left_wanted = cell_width(left.text) + left_padding if index == 1 else 0
    right_wanted = (
        sum(cell_width(part.text) for part in right) if is_last else 0
    )
    label = tab_label(draw_data, tab, index, content_width)
    label_width = cell_width(label)

    if extra_data.for_layout:
        # Kitty uses this cursor position to distribute space among tabs.
        ideal_width = (
            left_wanted + label_width + right_wanted
            + spacing + edge_width
        )
        screen.cursor.x = before + min(width, ideal_width)
        return screen.cursor.x

    minimum = min(label_width, cell_width(f' {index}: ') + MIN_TITLE_CELLS + 1)
    left_width, right_width = status_widths(
        left_wanted, right_wanted, max(0, content_width - minimum)
    )

    # Hide the session when its label and separator cannot fit together.
    if left_width <= left_padding + 1:
        left_width = 0
    screen.cursor.x = before
    if left_width:
        draw_segments(screen, [left], left_width - left_padding)
        if separator:
            set_style(screen, left.background, draw_data.tab_bg(tab))
            screen.draw(separator)
            screen.draw(POWERLINE_SOFT_SEPARATOR)
        else:
            bar_background = int(draw_data.default_bg)
            set_style(screen, bar_background, bar_background)
            screen.draw(' ' * TAB_SPACING)

    tab_width = content_width - left_width - right_width
    label = tab_label(draw_data, tab, index, tab_width)
    foreground = draw_data.tab_fg(tab)
    background = draw_data.tab_bg(tab)
    set_style(screen, foreground, background)
    draw_attributed_string(label, screen)

    if edge_width:
        next_tab = extra_data.next_tab if not is_last else None
        next_background = int(draw_data.default_bg)
        if next_tab is not None:
            next_background = (
                ACTIVE_TAB_BG if next_tab.is_active else INACTIVE_TAB_BG
            )
        # Use a fine diagonal at the active tab's edges for a lighter finish.
        if tab.is_active or (next_tab is not None and next_tab.is_active):
            if active_leading_edge:
                # Test a solid chevron followed by two fine strokes.
                set_style(screen, background, next_background)
                screen.draw(POWERLINE_SEPARATOR)
                screen.draw(POWERLINE_SOFT_SEPARATOR)
            else:
                # Preserve the existing fine-then-solid trailing edge.
                set_style(screen, next_background, background)
                screen.draw(POWERLINE_SOFT_SEPARATOR)
                set_style(screen, background, next_background)
                screen.draw(POWERLINE_SEPARATOR)
        elif is_last:
            # Finish the last tab with a solid Powerline tip into the bar.
            set_style(screen, background, background)
            screen.draw(' ')
            set_style(screen, background, next_background)
            screen.draw(POWERLINE_SEPARATOR)
        elif next_tab is not None and background == next_background:
            # Leave the first cell plain and put the fine stroke in the second.
            set_style(screen, background, background)
            screen.draw(' ')
            set_style(screen, foreground, background)
            screen.draw(POWERLINE_SOFT_SEPARATOR)
        else:
            # Keep the second fine separator; remove the first one.
            set_style(screen, background, background)
            screen.draw(' ')
            set_style(screen, next_background, background)
            screen.draw(POWERLINE_SOFT_SEPARATOR)

    if spacing:
        set_style(screen, int(draw_data.default_bg), int(draw_data.default_bg))
        screen.draw(' ' * spacing)

    if is_last:
        # Clear the gap with the bar background, then anchor status right.
        # Keep the cursor at the edge so Kitty's final erase preserves it.
        set_style(screen, int(draw_data.default_bg), int(draw_data.default_bg))
        screen.draw(' ' * (screen.columns - right_width - screen.cursor.x))
        if right_width:
            draw_segments(screen, right, right_width)

    # Kitty's ranges are inclusive and also determine bar alignment.
    return max(before, screen.cursor.x - 1)
