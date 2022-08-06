import os
import subprocess
# import time
from libqtile import qtile
from libqtile import bar, layout, widget, hook
from libqtile.lazy import lazy
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.utils import guess_terminal
from socket import gethostbyname, gethostname
from scripts import storage


mod = "mod4"
terminal = guess_terminal()
home_dir = os.path.expanduser('~')


@hook.subscribe.startup_once
def autostart():
    subprocess.Popen([home_dir + '/.config/qtile/scripts/autostart.sh'])


def get_monitors():
    xr = subprocess.check_output(
        'xrandr --query | grep " connected"', shell=True).decode().split('\n')
    monitors = len(xr) - 1 if len(xr) > 2 else len(xr)
    return monitors


monitors = get_monitors()

# Run autorandr --change and restart Qtile on screen change


@hook.subscribe.screen_change
def set_screen(event):
    subprocess.run(["autorandr," "--change"])
    qtile.restart()

# When application launched automatically focus it's groupp


@hook.subscribe.client_new
def modify_window(client):
    for group in groups:
        match = next((m for m in group.matches if m.compare(client)), None)
        if match:
            targetgroup = client.qtile.groups_map[group.name]
            targetgroup.cmd_toscreen(toggle=False)
            break


@hook.subscribe.client_managed
def make_urgent(window):
    atom = set([qtile.core.conn.atoms["_NET_WM_STATE_DEMANDS_ATTENTION"]])
    prev_state = set(window.window.get_property(
        "_NET_WM_STATE", "ATOM", unpack=int))
    new_state = prev_state | atom
    window.window.set_property("_NET_WM_STATE", list(new_state))


# ========= Theme Colors ===========
SOLARIZED = {"GREEN": '#00ff00',
             "ORANGE": '#ff9900',
             "RED": '#ff0000',
             "BASE03": '#002b36',
             "BASE02": '#073642',
             "BASE01": '#586e75',
             "BASE00": '#657b83',
             "BASE0":     '#839496',
             "BASE1": '#93a1a1',
             "BASE2": '#eee8d5',
             "BASE3": '#fdf6e3',
             "S_YELLOW": '#b58900',
             "S_ORANGE": '#cb4b16',
             "S_RED": '#dc322f',
             "S_MAGENTA": '#d33682',
             "S_VIOLET": '#6c71c4',
             "S_BLUE": '#268bd2',
             "S_CYAN": '#2aa198',
             "S_GREEN": '#859900'}

keys = [
    # Navegane panes
    Key([mod], "h",
        lazy.layout.left(),
        desc="Move focus to left"
        ),
    Key([mod], "l",
        lazy.layout.right(),
        desc="Move focus to right"
        ),
    Key([mod], "j",
        lazy.layout.down(),
        desc="Move focus down"
        ),
    Key([mod], "k",
        lazy.layout.up(),
        desc="Move focus up"
        ),
    Key([mod], "space",
        lazy.layout.next(),
        desc="Move window focus to other window"
        ),
    # Move Panes
    Key([mod, "shift"], "h",
        lazy.layout.shuffle_left(),
        desc="Move window to the left"
        ),
    Key([mod, "shift"], "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right"
        ),
    Key([mod, "shift"], "j",
        lazy.layout.shuffle_down(),
        desc="Move window down"
        ),
    Key([mod, "shift"], "k",
        lazy.layout.shuffle_up(),
        desc="Move window up"
        ),
    # Define size window
    Key([mod, "control"], "h",
        lazy.layout.grow_left(),
        desc="Grow window to the left"
        ),
    Key([mod, "control"], "l",
        lazy.layout.grow_right(),
        desc="Grow window to the right"
        ),
    Key([mod, "control"], "j",
        lazy.layout.grow_down(),
        desc="Grow window down"
        ),
    Key([mod, "control"], "k",
        lazy.layout.grow_up(),
        desc="Grow window up"
        ),
    # Reset size
    Key([mod], "n",
        lazy.layout.normalize(),
        desc="Reset all window sizes"
        ),
    Key([mod, "shift"], "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
        ),
    # Launch application
    Key([mod], "Return",
        lazy.spawn(terminal),
        desc="Launch terminal"
        ),
    # Toggle between different layouts as defined below
    Key([mod], "Tab",
        lazy.next_layout(),
        desc="Toggle between layouts"
        ),
    Key([mod, "shift"], "q",
        lazy.window.kill(),
        desc="Kill focused window"
        ),
    Key([mod, "shift"], "r",
        lazy.reload_config(),
        desc="Reload the config"
        ),
    Key([mod], "d",
        lazy.spawn("rofi -show combi"),
        desc="Launch Rofi menu"
        ),

    # +_+_+_+_+_+ Hardware Configs +_+_+_+_+_+
    # Volume
    Key([], "XF86AudioMute",
        lazy.spawn(home_dir + "/.local/bin/volume muted"),
        desc='Mute audio'
        ),
    Key([], "XF86AudioLowerVolume",
        lazy.spawn(home_dir + "/.local/bin/volume medium"),
        desc='Volume down'
        ),
    Key([], "XF86AudioRaiseVolume",
        lazy.spawn(home_dir + "/.local/bin/volume high"),
        desc='Volume up'
        ),

    # Media keys
    Key([], "XF86AudioPlay",
        lazy.spawn(
        "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify "\
        "/org/mpris/MediaPlayer2 " "org.mpris.MediaPlayer2.Player.PlayPause"
    ),
        desc='Audio play'
    ),
    Key([], "XF86AudioNext",
        lazy.spawn(
        "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify "\
        "/org/mpris/MediaPlayer2 " "org.mpris.MediaPlayer2.Player.Next"
    ),
        desc='Audio next'
    ),
    Key([], "XF86AudioPrev",
        lazy.spawn(
            "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify "
            "/org/mpris/MediaPlayer2 " "org.mpris.MediaPlayer2.Player.Previous"
    ),
        desc='Audio previous'
    ),

    Key([mod], "space",
        lazy.widget["keyboardlayout"].next_keyboard(),
        desc="Next keyboard layout."
        ),

    # Brightness
    Key([], "XF86MonBrightnessDown",
        lazy.spawn(home_dir + "/.local/bin/brightness down"),
        desc='Brightness down'
        ),
    Key([], "XF86MonBrightnessUp",
        lazy.spawn(home_dir + "/.local/bin/brightness up"),
        desc='Brightness up'
        ),

    Key([mod, "shift"], "e",
        lazy.spawn(home_dir + "/.local/bin/powermenu.sh"),
        desc="Run powermenu by rofi"
        ),

    Key([mod, "shift"], "space",
        lazy.window.toggle_floating(),
        desc="Toggle float mode"
        ),

    # Screenshots
    Key([mod], "Print",
        lazy.spawn("flameshot gui"),
        desc='Start screenshot provider'
        ),
]

# ========= Define Groups ===========
groups = [
    Group("1", layout="columns", matches=[
        Match(wm_class=["brave-browser"]),
        Match(wm_class=["firefox"]),
        Match(wm_class=["qutebrowser"])
    ]),

    Group("2", layout="monadwide", matches=[
        Match(wm_class=["Alacritty"])]),

    Group("3", layout="monadtall", matches=[
        Match(wm_class=["anki"])]),

    Group("4", layout="columns", matches=[
        Match(wm_class=["obsidian"]),
        Match(wm_class=["Thunderbird"]),
    ]),

    Group("5"),
    Group("6"),
    Group("7"),

    Group("8", layout="tile", matches=[
        Match(wm_class=["mousepad"]),
        Match(wm_class=["thunar"]),
        Match(wm_class=["audacity"])
    ]),

    Group("9", layout="monadtall", matches=[
        Match(wm_class=["transmission-gtk"]),
    ]),

]


for i in groups:
    keys.extend([
        Key([mod], i.name,
            lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name),
            ),
        Key([mod, "shift"], i.name,
            lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name),
            ),
        Key([mod, "control"], "Right",
            lazy.screen.next_group(),
            desc="Switch to next group"
            ),
        Key([mod, "control"], "Left",
            lazy.screen.prev_group(),
            desc="Switch to previous group"
            ),
    ])

# DEFAULT THEME SETTINGS FOR LAYOUTS #
lyt_theme = {"border_width": 2,
             "margin": 1,
             "font": "Source Code Pro Medium",
             "font_size": 10,
             "border_focus": SOLARIZED["S_RED"],
             "border_normal": SOLARIZED["BASE01"]
             }

layouts = [
    layout.MonadTall(**lyt_theme, single_margin=0, single_border_width=0),
    layout.MonadWide(**lyt_theme, single_margin=0, single_border_width=0),
    layout.MonadThreeCol(**lyt_theme, single_margin=0, single_border_width=0),
    layout.Tile(**lyt_theme,
                add_after_last=True,
                shift_windows=True,
                border_on_single=False,
                margin_on_single=False,
                ),
    layout.Columns(**lyt_theme,
                   border_focus_stack=[SOLARIZED["RED"], SOLARIZED["S_RED"]],
                   margin_on_single=0,
                   ),
    # layout.Floating(**lyt_theme),
    # layout.Spiral(**lyt_theme),
    # layout.Bsp(**lyt_theme),
    # layout.RatioTile(**lyt_theme),
    # layout.VerticalTile(**lyt_theme),
    # layout.Stack(num_stacks=2, **lyt_theme),
    # layout.Max(),
    # layout.Matrix(**lyt_theme),
    # layout.TreeTab()
    # layout.VerticalTile(),
    # layout.Zoomy(**lyt_theme, columnwidth=300),
]


def init_separator():
    return widget.Sep(
        margin=6,
        linewidth=2,
        padding=12,
        size_percent=70,
        # background=SOLARIZED["BASE03"],
        foreground=SOLARIZED["BASE02"])


def nerd_icon(nerdfont_icon, fg_color):
    return widget.TextBox(
        font="FiraCode Nerd Font",
        fontsize=12,
        text=nerdfont_icon,
        foreground=fg_color,
        # background=SOLARIZED["BASE01"]
    )


def init_edge_spacer():
    return widget.Spacer(
        length=5,
        background=SOLARIZED["BASE01"])


sep = init_separator()
space = init_edge_spacer()

widget_defaults = dict(
    font="Source Code Pro Medium",
    # foreground=SOLARIZED["BASE2"],
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()


def init_widgets_list():
    widget_list = [
        widget.CurrentLayoutIcon(scale=0.8),
        widget.GroupBox(
            font="Hack Nerd Font",
            fontsize=13,
            foreground=SOLARIZED["BASE2"],
            # background=SOLARIZED["BASE02"],
            borderwidth=3,
            highlight_method="line",
            this_current_screen_border=SOLARIZED["S_BLUE"],
            active=SOLARIZED["BASE3"],
            inactive=SOLARIZED["BASE00"],
        ),
        sep,
        widget.WindowName(max_chars=30),
        widget.Chord(
            chords_colors={
                "launch": ("#ff0000", "#ffffff"),
            },
            name_transform=lambda name: name.upper(),
        ),
        # sep,
        # nerd_icon("", SOLARIZED["BASE01"]),
        # widget.GenPollText(
        #     update_interval=5,
        #     func=lambda: subprocess.check_output(
        #         f"{home_dir}/.config/qtile/scripts/instaled-pkgs.sh".decode(
        #             "utf-8")
        #     ),
        # ),
        nerd_icon(" ", SOLARIZED["BASE00"]),
        widget.Wlan(
            foreground=SOLARIZED["GREEN"],
            format='({percent:2.0%})'
        ),
        widget.GenPollText(
            update_interval=5,
            foreground=SOLARIZED["GREEN"],
            func=lambda: gethostbyname(gethostname()),
            mouse_callbacks={
                'Button1': lambda: qtile.cmd_spawn(f"{terminal} -e nmcli")
            }
        ),
        sep,
        nerd_icon(" ", SOLARIZED["BASE00"]),
        widget.KeyboardLayout(
            configured_keyboards=['us', 'br'],
        ),
        sep,
        nerd_icon("墳 ", SOLARIZED["BASE00"]),
        widget.PulseVolume(
            get_volume_command="pamixer --get-volume",
            mouse_callbacks={
                'Button1': lambda: qtile.cmd_spawn("pavucontrol")
            }
        ),
        sep,
        nerd_icon(" ", SOLARIZED["BASE00"]),
        widget.GenPollText(
            update_interval=5,
            func=lambda: storage.diskspace('FreeSpace'),
            mouse_callbacks={
                'Button1': lambda: qtile.cmd_spawn("gparted")
            }
        ),
        sep,
        widget.Battery(
            format="{char}{percent:2.0%}",
            full_char=' FULL ',
            charge_char='  CHR ',
            discharge_char=' BAT ',
            empty_char=' No battery',
            unknown_char=' UNK',
            low_percentage=0.15,
        ),
        sep,
        nerd_icon(" ", SOLARIZED["BASE00"]),
        widget.Clock(
            # format="%I:%M %p",
            format="%H:%M",
        ),
        nerd_icon("  ", SOLARIZED["BASE00"]),
        widget.Clock(
            format="%b %d-%Y",
            mouse_callbacks={
                'Button1': lambda: qtile.cmd_spawn(
                    home_dir + "/.config/qtile/scripts/show_calendar.sh"
                )
            }
        ),
        sep,
        widget.Systray(),
    ]
    return widget_list


def init_screens():
    return [Screen(top=bar.Bar(
        widgets=init_widgets_list(),
        size=24,
        # opacity=0.9,
        # margin=[5, 10, 0, 0.10]
    ))]


screens = init_screens()

# Drag floating layouts.
mouse = [
    Drag(
        [mod], "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position()
    ),
    Drag(
        [mod], "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size()
    ),
    Click(
        [mod], "Button2",
        lazy.window.bring_to_front()
    ),
]

floating_layout = layout.Floating(float_rules=[
    *layout.Floating.default_float_rules,
    Match(wm_class="confirmreset"),  # gitk
    Match(wm_class="makebranch"),  # gitk
    Match(wm_class="maketag"),  # gitk
    Match(wm_class="ssh-askpass"),  # ssh-askpass
    Match(wm_class="gufw.py"),
    Match(wm_class="Blueman-manager"),
    Match(wm_class="Arandr"),
    Match(wm_class="Simple-scan"),
    Match(wm_class="Lxappearance"),
    Match(wm_class="pavucontrol"),
    Match(wm_class="GParted"),
    Match(wm_class="gcr-prompter"),  # Gnome-Keyring

    Match(title="branchdialog"),  # gitk
    Match(title="pinentry"),  # GPG key password entry
    Match(title='Qalculate!'),
], **lyt_theme)

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "Qtile"
