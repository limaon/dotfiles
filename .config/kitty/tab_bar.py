# pyright: reportMissingImports=false
# vim:ft=python
# ============================================================================
# Custom tab bar for Kitty - Solarized Osaka theme
# ============================================================================
# Layout (left -> right):
#   [ session name ]        [ centered tabs ]        [ status: mode/layout ]
#
# Docs: https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.tab_bar_style
# ============================================================================

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, get_options
from kitty.rgb import color_from_int
from kitty.tab_bar import (DrawData, ExtraData, TabBarData, as_rgb, draw_title,
                           wcswidth)
from kitty.utils import color_as_int

opts = get_options()

# State for centering
_tab_widths: list[int] = []
_active_idx: int = 0


class CustomDrawData:
    """Wrapper around DrawData that overrides tab colors for active tabs."""
    def __init__(self, draw_data, active_fg, active_bg):
        self._dd = draw_data
        self._active_fg = color_from_int(active_fg)
        self._active_bg = color_from_int(active_bg)

    def tab_fg(self, tab):
        if tab.is_active:
            return self._active_fg
        return self._dd.tab_fg(tab)

    def tab_bg(self, tab):
        if tab.is_active:
            return self._active_bg
        return self._dd.tab_bg(tab)

    def __getattr__(self, name):
        return getattr(self._dd, name)


class DrawTab:
    """
    Custom tab bar - Solarized Osaka theme

    Layout: [ session name ] [ centered tabs ] [ status: mode/layout ]
    """

    def __init__(self) -> None:
        # Theme colors from kitty.conf
        self.RED = as_rgb(color_as_int(opts.color1))
        self.GREEN = as_rgb(color_as_int(opts.color2))
        self.YELLOW = as_rgb(color_as_int(opts.color3))
        self.BLUE = as_rgb(color_as_int(opts.color4))
        self.CYAN = as_rgb(color_as_int(opts.color6))

        # Custom colors
        self.SESSION_BG = as_rgb(0x657b83)
        self.ACTIVE_TAB_BG = as_rgb(0x1a6497)
        self.ACTIVE_TAB_FG = as_rgb(0xb8c1c1)
        self.INACTIVE_TAB_BG = as_rgb(0x111a20)
        self.MODE_FG = as_rgb(0xadb8b8)
        self.MODE_BG = as_rgb(0xb7221e)
        self.NORMAL_BG = as_rgb(0x1a6497)

        # Icons
        self.ICON_SESSION = '\uf07b'
        self.ICON_MODE = '\uf11c'
        self.ICON_LAYOUT = '\uf0db'

        # Block widths
        self.LEFT_BLOCK_W = 13
        self.RIGHT_BLOCK_W = 19

    def draw_left_status(self, screen, draw_data):
        boss = get_boss()
        session_name = boss.active_session or 'default'
        screen.cursor.fg = as_rgb(int(draw_data.default_bg))
        screen.cursor.bg = self.SESSION_BG
        screen.cursor.italic = False
        screen.cursor.bold = True
        screen.draw(f' [SESSION: {session_name}] ')
        screen.cursor.bold = False

    def draw_right_status(self, screen, draw_data):
        boss = get_boss()
        mode = boss.mappings.current_keyboard_mode_name or 'normal'
        layout = boss.active_tab.current_layout.name
        mode_str = f' {self.ICON_MODE} prefix '
        layout_str = f' {self.ICON_LAYOUT} {layout} '
        mode_w = wcswidth(mode_str)
        layout_w = wcswidth(layout_str)
        screen.cursor.x = screen.columns - mode_w - layout_w - 2

        # Yellow bar
        screen.cursor.fg = as_rgb(int(draw_data.default_bg))
        screen.cursor.bg = self.YELLOW
        screen.draw(' ')

        # Mode (red bg when not normal)
        mode_display = 'prefix' if mode != 'normal' else mode
        screen.cursor.fg = self.MODE_FG
        screen.cursor.bg = self.MODE_BG if mode != 'normal' else self.NORMAL_BG
        screen.draw(f' {self.ICON_MODE} {mode_display} ')

        # Layout
        screen.cursor.fg = self.ACTIVE_TAB_FG
        screen.cursor.bg = self.ACTIVE_TAB_BG
        screen.draw(layout_str)

        # Green bar
        screen.cursor.fg = as_rgb(int(draw_data.default_bg))
        screen.cursor.bg = self.GREEN
        screen.draw(' ')

    def draw_tab(self, draw_data, screen, tab, before, max_tab_length, index, is_last, extra_data):
        global _tab_widths, _active_idx
        idx = index - 1

        if extra_data.for_layout:
            if idx == 0:
                _tab_widths = []
                _active_idx = 0
            start_x = screen.cursor.x
            screen.draw(f' {index}: ')
            draw_title(draw_data, screen, tab, index, screen.columns)
            screen.draw('  ')
            _tab_widths.append(screen.cursor.x - start_x)
            if tab.is_active:
                _active_idx = idx
            screen.cursor.x = before + 1
            return screen.cursor.x

        # --- Draw pass ---
        if idx >= len(_tab_widths):
            return screen.cursor.x

        available = screen.columns - self.LEFT_BLOCK_W - self.RIGHT_BLOCK_W
        total_w = sum(_tab_widths)
        n = len(_tab_widths)

        if n > 0 and total_w < available:
            start_x = self.LEFT_BLOCK_W + (available - total_w) // 2
        else:
            start_x = self.LEFT_BLOCK_W

        if index == 1:
            self.draw_left_status(screen, draw_data)

        screen.cursor.x = start_x + sum(_tab_widths[:idx])
        screen.cursor.fg = self.ACTIVE_TAB_FG if tab.is_active else as_rgb(draw_data.tab_fg(tab))
        screen.cursor.bg = self.ACTIVE_TAB_BG if tab.is_active else self.INACTIVE_TAB_BG
        screen.cursor.italic = False
        screen.cursor.bold = False
        screen.draw(f' {index}: ')
        screen.cursor.bold = False

        if tab.is_active:
            custom_dd = CustomDrawData(draw_data, self.ACTIVE_TAB_FG, self.ACTIVE_TAB_BG)
            draw_title(custom_dd, screen, tab, index, _tab_widths[idx] - 4)
        else:
            draw_title(draw_data, screen, tab, index, _tab_widths[idx] - 4)

        screen.draw(' ')

        if is_last:
            self.draw_right_status(screen, draw_data)

        return screen.cursor.x


_tab = DrawTab()


def draw_tab(*args) -> int:
    return _tab.draw_tab(*args)
