# pylint: disable=C0111

# Set default Web Browser command:
# xdg-settings set default-web-browser org.qutebrowser.qutebrowser.desktop
# Back to Firefox
# xdg-settings set default-web-browser firefox.desktop

from PyQt6.QtCore import QUrl
from qutebrowser.api import interceptor, message
from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer
from urllib.parse import urljoin
import operator
import re

# pylint: disable=C0111
c: ConfigContainer = c  # noqa: F821 pylint: disable=E0602,C0103
config: ConfigAPI = config  # noqa: F821 pylint: disable=E0602,C0103
dowmload_open_script_path = "/usr/share/qutebrowser/userscripts/open_download"
config.load_autoconfig()


# REDIRECT CONFIG
def _debian_redir(url: QUrl) -> bool:
    p = url.path().strip("/")
    if p.isdigit():
        url.setPath(urljoin("/plain/", p))
        return True
    return False


def _the_compiler_redir(url: QUrl) -> bool:
    p = url.path().strip("/")
    res = re.search(r"\w+$", p)
    if p.startswith("view/") and res:
        url.setPath(urljoin("/view/raw/", res.group()))
        return True
    return False


def _pastebin_redir(url: QUrl) -> bool:
    p = url.path().strip("/")
    if p.isalnum():
        url.setPath(urljoin("/raw/", p))
        return True
    return False


def _hastebin_redir(url: QUrl) -> bool:
    p = url.path().strip("/")
    if "raw" not in p:
        url.setPath(urljoin("/raw/", p))
        return True
    return False


# Any return value other than a literal 'False' means we redirected
# type: typing.Dict[str, typing.Callable[..., typing.Optional[bool]]]
REDIRECT_MAP = {
    "reddit.com": operator.methodcaller("setHost", "reddit.rtrace.io"),
    "www.reddit.com": operator.methodcaller("setHost", "reddit.rtrace.io"),
    "twitter.com": operator.methodcaller("setHost", "mobile.twitter.com"),
    "www.twitter.com": operator.methodcaller("setHost", "mobile.twitter.com"),
    "medium.com": operator.methodcaller("setHost", "md.vern.cc"),
    "www.medium.com": operator.methodcaller("setHost", "md.vern.cc"),
    # "youtube.com": operator.methodcaller('setHost', 'piped.video'),
    # "www.youtube.com": operator.methodcaller('setHost', 'piped.video'),
    # "en.wikipedia.org": operator.methodcaller("setHost", "wikiless.org"),
    # "www.en.wikipedia.org": operator.methodcaller("setHost", "wikiless.org"),
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
    if (
        info.resource_type != interceptor.ResourceType.main_frame
        or info.request_url.scheme() in {"data", "blob"}
    ):
        return
    url = info.request_url

    redir = REDIRECT_MAP.get(url.host())
    if redir is not None and redir(url) is not False:
        message.info("Redirecting to " + url.toString())
        info.redirect(url)


interceptor.register(int_fn)


# Fonts
c.fonts.default_family = [
    "Terminess Nerd Font",
    "Noto Sans CJK JP",
    "Noto Color Emoji",
]
c.fonts.default_size = "14pt"
c.fonts.web.family.standard = "Inter"
c.fonts.web.family.sans_serif = "Inter"
c.fonts.web.family.serif = "Noto Serif"
c.fonts.web.family.fixed = "JetBrainsMono Nerd Font"
c.fonts.hints = "bold 12pt default_family"
c.fonts.contextmenu = "default_size default_family"
c.fonts.debug_console = "default_size default_family"
c.fonts.completion.category = "bold default_size default_family"
c.fonts.completion.entry = "default_size default_family"
c.fonts.tooltip = "default_size default_family"
c.fonts.downloads = "default_size default_family"
c.fonts.web.size.default = 20
c.fonts.web.size.default_fixed = 18
c.fonts.web.size.minimum = 14
c.fonts.web.size.minimum_logical = 12


c.hints.auto_follow = "unique-match"
c.hints.padding = {'bottom': 1, 'left': 3, 'right': 3, 'top': 1}
c.hints.uppercase = True

# c.content.user_stylesheets = ["./styles/youtube-tweaks.css"]
c.content.user_stylesheets = ["./styles/global.css"]

# Dark mode
c.colors.webpage.darkmode.enabled = False
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
c.colors.webpage.darkmode.policy.images = "never"
c.colors.webpage.darkmode.policy.page = "always"
c.colors.webpage.bg = "#303030"
config.set('colors.webpage.darkmode.enabled', False, 'file://*')

c.completion.shrink = True
c.completion.use_best_match = True
c.completion.open_categories = ["bookmarks", "history", "filesystem"]
c.completion.height = '20%'
c.completion.web_history.max_items = 40
c.scrolling.bar = "when-searching"
c.scrolling.smooth = False
c.statusbar.widgets = ["progress", "keypress", "url", "history"]

# Browser Tabs
c.tabs.title.format = "{index}: {audio}{current_title}"
c.tabs.title.format_pinned = "{index}: {audio}{current_title}"
c.tabs.padding = {'top': 2, 'bottom': 2, 'left': 10, 'right': 10}
c.tabs.mousewheel_switching = False
c.tabs.width = '8%'
c.tabs.indicator.width = 0
c.tabs.select_on_remove = "last-used"
c.tabs.show = "multiple"
c.tabs.last_close = "close"
c.tabs.mousewheel_switching = False

c.url.default_page = "https://duckduckgo.com/"
c.url.start_pages = ["https://duckduckgo.com/"]
c.url.auto_search = "schemeless"
c.completion.quick = True

# GENERAL
c.input.insert_mode.auto_load = False
c.content.default_encoding = "utf-8"
c.auto_save.session = True
c.content.prefers_reduced_motion = False
c.content.xss_auditing = True
c.content.javascript.modal_dialog = True
c.content.javascript.clipboard = "access-paste"
c.content.notifications.enabled = "ask"
c.content.notifications.presenter = "auto"
c.content.notifications.show_origin = True
c.content.javascript.can_open_tabs_automatically = True
c.content.autoplay = False
c.content.plugins = False
c.content.pdfjs = False
c.content.images = True
c.content.blocking.method = "auto"
c.content.blocking.enabled = True
c.downloads.location.prompt = True
c.downloads.open_dispatcher = dowmload_open_script_path
c.downloads.remove_finished = 10000
c.downloads.location.directory = "~/Downloads/"
c.editor.command = ["kitty", "-e", "nvim", "+{line}", "{file}"]
c.qt.highdpi = True
c.qt.chromium.process_model = "process-per-site"
c.qt.chromium.low_end_device_mode = "auto"
c.qt.args += [
    "--widevine"
]


# Keybinds
config.unbind("m")
bindings = {
    "pd": "config-cycle colors.webpage.darkmode.enabled",
    "pw": "spawn -u qute-keepassxc --key 7265E01E8E939A67",
    "pt": "spawn -u qute-keepassxc --key 7265E01E8E939A67 --totp",
    "pf": "spawn -u password_fill",
    ",m": "spawn -u view_in_mpv",
    ",M": "hint links spawn -u view_in_mpv {hint-url}",
    ",f": "hint all spawn -d firefox {hint-url}",
}
for key, bind in bindings.items():
    config.bind(key, bind)

# Select a file to upload
c.fileselect.handler = "default"
c.fileselect.single_file.command = ["kitty", "sh", "-c", "lf > {}"]
c.fileselect.multiple_files.command = ["kitty", "sh", "-c", "lf > {}"]


# Privacy
config.set("content.webgl", False, "*")
config.set("content.canvas_reading", False)
config.set("content.geolocation", False)
config.set("content.webrtc_ip_handling_policy",
           "default-public-interface-only")
config.set("content.cookies.accept", "all")
config.set("content.cookies.store", True)


# config.set("content.cookies.accept", "all", "chrome-devtools://*")
# config.set("content.cookies.accept", "all", "devtools://*")
# config.set("content.headers.accept_language", "", "https://matchmaker.krunker.io/*")
# config.set("content.images", True, "chrome-devtools://*")
# config.set("content.images", True, "devtools://*")
# config.set("content.javascript.enabled", True, "chrome-devtools://*")
# config.set("content.javascript.enabled", True, "devtools://*")
# config.set("content.javascript.enabled", True, "chrome://*/*")
# config.set("content.javascript.enabled", True, "qute://*/*")
