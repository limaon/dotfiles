from PyQt5.QtCore import QUrl
from qutebrowser.api import interceptor, message
from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer
import operator
import re
import typing
from urllib.parse import urljoin
config: ConfigAPI = config
c: ConfigContainer = c
dowmload_open_script_path = "/usr/share/qutebrowser/userscripts/open_download"


def _debian_redir(url: QUrl) -> bool:
    p = url.path().strip('/')
    if p.isdigit():
        url.setPath(urljoin("/plain/", p))
        return True
    return False


def _the_compiler_redir(url: QUrl) -> bool:
    p = url.path().strip('/')
    res = re.search(r"\w+$", p)
    if p.startswith('view/') and res:
        url.setPath(urljoin("/view/raw/", res.group()))
        return True
    return False


def _pastebin_redir(url: QUrl) -> bool:
    p = url.path().strip('/')
    if p.isalnum():
        url.setPath(urljoin("/raw/", p))
        return True
    return False


def _hastebin_redir(url: QUrl) -> bool:
    p = url.path().strip('/')
    if "raw" not in p:
        url.setPath(urljoin("/raw/", p))
        return True
    return False


# Any return value other than a literal 'False' means we redirected
# type: typing.Dict[str, typing.Callable[..., typing.Optional[bool]]]
REDIRECT_MAP = {
    "reddit.com": operator.methodcaller('setHost', 'libreddit.de'),
    "www.reddit.com": operator.methodcaller('setHost', 'libreddit.de'),
    "twitter.com": operator.methodcaller('setHost', 'mobile.twitter.com'),
    "www.twitter.com": operator.methodcaller('setHost', 'mobile.twitter.com'),
    "youtube.com": operator.methodcaller('setHost', 'yt.artemislena.eu'),
    "www.youtube.com": operator.methodcaller('setHost', 'yt.artemislena.eu'),
    "en.wikipedia.org": operator.methodcaller('setHost', 'wikiless.org'),
    "www.en.wikipedia.org": operator.methodcaller('setHost', 'wikiless.org'),
    "medium.com": operator.methodcaller('setHost', 'scribe.rip'),
    "www.medium.com": operator.methodcaller('setHost', 'scribe.rip'),


    "pt.wikipedia.org": operator.methodcaller('setHost', 'wikiless.org'),
    "www.pt.wikipedia.org": operator.methodcaller('setHost', 'wikiless.org'),

    # Pastebins
    "paste.debian.net": _debian_redir,
    "paste.the-compiler.org": _the_compiler_redir,
    # Causes an infinite loop if the paste does not exist...
    "pastebin.com": _pastebin_redir,
    "hasteb.in": _hastebin_redir,
    "hastebin.com": _hastebin_redir,
}


def int_fn(info: interceptor.Request):
    """Block the given request if necessary."""
    if (info.resource_type != interceptor.ResourceType.main_frame or
            info.request_url.scheme() in {"data", "blob"}):
        return
    url = info.request_url

    redir = REDIRECT_MAP.get(url.host())
    if redir is not None and redir(url) is not False:
        message.info("Redirecting to " + url.toString())
        info.redirect(url)


interceptor.register(int_fn)


# Uncomment this to still load settings configured via autoconfig.yml
config.load_autoconfig(False)

# ui
c.fonts.default_family = ["JetBrainsMono Nerd Font", "JoyPixels"]
c.fonts.default_size = "13px"
c.colors.webpage.preferred_color_scheme = "dark"
c.completion.shrink = True
c.completion.use_best_match = True
c.downloads.position = "bottom"
c.downloads.remove_finished = 30000
c.statusbar.widgets = ["keypress", "progress", "url", "scroll"]
c.scrolling.bar = "always"
c.tabs.title.format = "{index}: {audio}{current_title}"
c.tabs.title.format_pinned = "{index}: {audio}{current_title}"
c.tabs.select_on_remove = "last-used"
c.tabs.width = "20%"
c.tabs.indicator.width = 5
c.tabs.padding = {"bottom": 1, "left": 5, "right": 5, "top": 1}
c.url.auto_search = "dns"
c.url.default_page = "https://duckduckgo.com/"
c.url.start_pages = ["https://duckduckgo.com/"]
c.url.start_pages.append("https://yewtu.be/feed/subscriptions")
# c.url.searchengines = {
#     "DEFAULT": "https://duckduckgo.com/search?q={}"
#     "DEFAULT": "https://searxng.tordenskjold.de/search?q={}"
# }

# general
c.editor.encoding = 'utf-8'
c.content.default_encoding = "utf-8"
c.content.javascript.can_access_clipboard = True
c.input.insert_mode.auto_load = True
c.auto_save.session = True
c.spellcheck.languages = ["pt-BR"]
c.downloads.location.prompt = False
c.downloads.open_dispatcher = dowmload_open_script_path
c.tabs.show = "always"
c.tabs.last_close = "close"
c.tabs.mousewheel_switching = False
c.content.autoplay = True
c.content.pdfjs = False  # Don't view pdf files in-browser
c.downloads.location.directory = "~/Downloads/"
c.downloads.location.prompt = False
c.content.canvas_reading = False
c.content.webgl = True
c.scrolling.smooth = False
c.scrolling.bar = "when-searching"
c.qt.highdpi = True
c.qt.force_software_rendering = "qt-quick"
c.qt.args += [
    "enable-gpu-rasterization",
    "blink-settings=preferredColorScheme=1",
]
c.editor.command = ["kitty", "-e", "nvim", "{file}"]
c.aliases = {'q': 'quit', 'w': 'session-save', 'wq': 'quit --save'}

# Keybinds
config.unbind('m')
bindings = {
    'M': 'hint links spawn --userscript view_in_mpv {hint-url}',
    ';M': 'spawn kitty -e yt-dlp --embed-metadata \
        --embed-thumbnail -i -o "~/Videos/%(title)s.%(ext)s" -f mp4 \
        --sponsorblock-remove all --write-sub --sub-lang en \
        --convert-subs vtt {url}',
    'pf': 'spawn --userscript password_fill',
    'mf': 'hint all spawn -d firefox {hint-url}',
    '<f12>': 'devtools bottom',
}

for key, bind in bindings.items():
    config.bind(key, bind)

# Select a file to upload
c.fileselect.handler = "external"
c.fileselect.single_file.command = [
    'kitty', '--class', 'ranger,ranger', '-e',
    'ranger', '--choosefile', '{}'
]
c.fileselect.multiple_files.command = [
    'kitty', '--class', 'ranger,ranger', '-e',
    'ranger', '--choosefiles', '{}'
]

# Chars used for hint strings.
c.hints.chars = "asdfghjklie"
c.hints.leave_on_load = False  # Don't lead hint mode when page loads
# c.hints.find_implementation = 'javascript'

config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')


c.completion.timestamp_format = '%Y-%m-%d %H:%M'

# Adblock filter lists
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
    "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
    "https://easylist.to/easylist/fanboy-social.txt"
]

c.content.blocking.enabled = True
c.content.blocking.hosts.lists = [
    'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts'
]
c.content.blocking.method = "auto"

# Privacity
c.content.cookies.accept = "no-3rdparty"
c.content.webrtc_ip_handling_policy = "default-public-interface-only"
c.content.site_specific_quirks.enabled = False
c.content.headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) \
AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36"

# base16-qutebrowser (https://github.com/theova/base16-qutebrowser)
# Base16 qutebrowser template by theova
# Solarized Dark scheme by Ethan Schoonover (modified by aramisgithub)

base00 = "#002b36"
base01 = "#073642"
base02 = "#586e75"
base03 = "#657b83"
base04 = "#839496"
base05 = "#93a1a1"
base06 = "#eee8d5"
base07 = "#fdf6e3"
base08 = "#dc322f"
base09 = "#cb4b16"
base0A = "#b58900"
base0B = "#859900"
base0C = "#2aa198"
base0D = "#268bd2"
base0E = "#6c71c4"
base0F = "#d33682"

# set qutebrowser colors (Theme: Solarized)
c.colors.completion.fg = base05
c.colors.completion.odd.bg = base01
c.colors.completion.even.bg = base00
c.colors.completion.category.fg = base0A
c.colors.completion.category.bg = base00
c.colors.completion.category.border.top = base00
c.colors.completion.category.border.bottom = base00
c.colors.completion.item.selected.fg = base05
c.colors.completion.item.selected.bg = base02
c.colors.completion.item.selected.border.top = base02
c.colors.completion.item.selected.border.bottom = base02
c.colors.completion.item.selected.match.fg = base0B
c.colors.completion.match.fg = base0B
c.colors.completion.scrollbar.fg = base05
c.colors.completion.scrollbar.bg = base00
c.colors.contextmenu.disabled.bg = base01
c.colors.contextmenu.disabled.fg = base04
c.colors.contextmenu.menu.bg = base00
c.colors.contextmenu.menu.fg = base05
c.colors.contextmenu.selected.bg = base02
c.colors.contextmenu.selected.fg = base05
c.colors.downloads.bar.bg = base00
c.colors.downloads.start.fg = base00
c.colors.downloads.start.bg = base0D
c.colors.downloads.stop.fg = base00
c.colors.downloads.stop.bg = base0C
c.colors.downloads.error.fg = base08
c.colors.hints.fg = base00
c.colors.hints.bg = base0A
c.colors.hints.match.fg = base05
c.colors.keyhint.fg = base05
c.colors.keyhint.suffix.fg = base05
c.colors.keyhint.bg = base00
c.colors.messages.error.fg = base00
c.colors.messages.error.bg = base08
c.colors.messages.error.border = base08
c.colors.messages.warning.fg = base00
c.colors.messages.warning.bg = base0E
c.colors.messages.warning.border = base0E
c.colors.messages.info.fg = base05
c.colors.messages.info.bg = base00
c.colors.messages.info.border = base00
c.colors.prompts.fg = base05
c.colors.prompts.border = base00
c.colors.prompts.bg = base00
c.colors.prompts.selected.bg = base02
c.colors.prompts.selected.fg = base05
c.colors.statusbar.normal.fg = base0B
c.colors.statusbar.normal.bg = base00
c.colors.statusbar.insert.fg = base00
c.colors.statusbar.insert.bg = base0D
c.colors.statusbar.passthrough.fg = base00
c.colors.statusbar.passthrough.bg = base0C
c.colors.statusbar.private.fg = base00
c.colors.statusbar.private.bg = base01
c.colors.statusbar.command.fg = base05
c.colors.statusbar.command.bg = base00
c.colors.statusbar.command.private.fg = base05
c.colors.statusbar.command.private.bg = base00
c.colors.statusbar.caret.fg = base00
c.colors.statusbar.caret.bg = base0E
c.colors.statusbar.caret.selection.fg = base00
c.colors.statusbar.caret.selection.bg = base0D
c.colors.statusbar.progress.bg = base0D
c.colors.statusbar.url.fg = base05
c.colors.statusbar.url.error.fg = base08
c.colors.statusbar.url.hover.fg = base05
c.colors.statusbar.url.success.http.fg = base0C
c.colors.statusbar.url.success.https.fg = base0B
c.colors.statusbar.url.warn.fg = base0E
c.colors.tabs.bar.bg = base00
c.colors.tabs.indicator.start = base0D
c.colors.tabs.indicator.stop = base0C
c.colors.tabs.indicator.error = base08
c.colors.tabs.odd.fg = base05
c.colors.tabs.odd.bg = base01
c.colors.tabs.even.fg = base05
c.colors.tabs.even.bg = base00
c.colors.tabs.pinned.even.bg = base0C
c.colors.tabs.pinned.even.fg = base07
c.colors.tabs.pinned.odd.bg = base0B
c.colors.tabs.pinned.odd.fg = base07
c.colors.tabs.pinned.selected.even.bg = base02
c.colors.tabs.pinned.selected.even.fg = base05
c.colors.tabs.pinned.selected.odd.bg = base02
c.colors.tabs.pinned.selected.odd.fg = base05
c.colors.tabs.selected.odd.fg = base05
c.colors.tabs.selected.odd.bg = base02
c.colors.tabs.selected.even.fg = base05
c.colors.tabs.selected.even.bg = base02

# Background color for webpages if unset (or empty to use the theme's
# color).
# c.colors.webpage.bg = base00
