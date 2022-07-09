import os
import subprocess
import time
from libqtile import qtile
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile import hook
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal


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

# When application launched automatically focus it's group


@hook.subscribe.client_new
def modify_window(client):
    for group in groups:
        match = next((m for m in group.matches if m.compare(client)), None)
        if match:
            targetgroup = client.qtile.groups_map[group.name]
            targetgroup.cmd_toscreen(toggle=False)
            break


"""
Hook to fallback to the first group with
windows when last window of group is killed
"""


@hook.subscribe.client_killed
def fallback(window):
    if window.groups.window != [window]:
        return
    idx = qtile.groups.index(window.group)
    for group in qtile.group[idx - 1::-1]:
        if group.windows:
            qtile.current_screen.toggle_group(group)
            return
        qtile.current_screen.toggle_group(qtile.group[0])

# Work around for matching Spotify


@hook.subscribe.cliente_new
def slight_delay(window):
    time.sleep(0.04)


mod = "mod4"
terminal = guess_terminal()
home_dir = os.path.expanduser('~')

MYCOLORS = [
    '#00ff00', '#ff9900', '#ff0000', '#002b36',
    '#073642', '#586e75', '#657b83', '#839496',
    '#93a1a1', '#eee8d5', '#fdf6e3', '#b58900',
    '#cb4b16', '#dc322f', '#d33682', '#6c71c4',
    '#268bd2', '#2aa198', '#859900',
]

GREEN = MYCOLORS[0]
ORANGE = MYCOLORS[1]
RED = MYCOLORS[2]
BASE03 = MYCOLORS[3]
BASE02 = MYCOLORS[4]
BASE01 = MYCOLORS[5]
BASE00 = MYCOLORS[6]
BASE1 = MYCOLORS[7]
BASE2 = MYCOLORS[8]
BASE3 = MYCOLORS[9]
S_YELLOW = MYCOLORS[10]
S_ORANGE = MYCOLORS[11]
S_RED = MYCOLORS[12]
S_MAGENTA = MYCOLORS[13]
S_VIOLET = MYCOLORS[14]
S_BLUE = MYCOLORS[15]
S_CYAN = MYCOLORS[16]
S_GREEN = MYCOLORS[17]

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
        lazy.spawn(home_dir + "/.local/bin/volume mute"),
        desc='Mute audio'
        ),
    Key([], "XF86AudioLowerVolume",
        lazy.spawn(home_dir + "/.local/bin/volume down"),
        desc='Volume down'
        ),
    Key([], "XF86AudioRaiseVolume",
        lazy.spawn(home_dir + "/.local/bin/volume up"),
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

    # Brightness
    Key([], "XF86MonBrightnessDown",
        lazy.spawn(home_dir + "/.local/bin/brightness down"),
        desc='Brightness down'
        ),
    Key([], "XF86MonBrightnessUp",
        lazy.spawn(home_dir + "/.local/bin/brightness up"),
        desc='Brightness up'
        ),

    # Screenshots
    # Save screen to clipboard
    Key([mod], "Print",
        lazy.spawn("flameshot gui"),
        desc='Start screenshot provider'
        ),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod], i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window
            Key(
                [mod, "shift"], i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(
                    i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="Hack Nerd Font",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.TextBox("default config", name="default"),
                widget.TextBox("Press &lt;M-r&gt; to spawn",
                               foreground="#d75f5f"),
                widget.Systray(),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
                widget.QuickExit(),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]
            # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to
        # see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
