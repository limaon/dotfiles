from PyQt6.QtCore import QUrl
from qutebrowser.api import interceptor, message
from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer
from urllib.parse import urljoin
import operator
import re

config: ConfigAPI = config
c: ConfigContainer = c
dowmload_open_script_path = "/usr/share/qutebrowser/userscripts/open_download"
config.load_autoconfig(False)


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


# UI
c.fonts.default_family = [
    "Terminus",
    "Ubuntu Mono",
    "Noto Sans CJK JP",
    "Noto Color Emoji",
]
c.fonts.default_size = "16px"
c.downloads.remove_finished = 10000
c.colors.webpage.darkmode.enabled = False
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.policy.page = "always"
c.completion.shrink = True
c.completion.use_best_match = True
c.scrolling.bar = "when-searching"
c.statusbar.widgets = ["progress", "keypress", "url", "history"]
c.tabs.title.format = "{index}: {audio}{current_title}"
c.tabs.title.format_pinned = "{index}: {audio}{current_title}"
c.tabs.mousewheel_switching = False
c.tabs.width = 150
c.tabs.select_on_remove = "last-used"
c.tabs.show = "multiple"
c.tabs.last_close = "close"
c.tabs.mousewheel_switching = False
c.fonts.hints = "bold 11pt default_family"
c.url.default_page = "https://duckduckgo.com/"
c.url.start_pages = ["https://duckduckgo.com/"]

# GENERAL
c.input.insert_mode.auto_load = False
c.content.default_encoding = "utf-8"
c.auto_save.session = False
c.content.prefers_reduced_motion = True
c.content.xss_auditing = True
c.content.javascript.modal_dialog = True
c.content.javascript.clipboard = "access-paste"
c.content.notifications.enabled = "ask"
c.content.notifications.presenter = "auto"
c.content.notifications.show_origin = True
c.content.javascript.can_open_tabs_automatically = True
c.downloads.location.prompt = False
c.content.autoplay = False
c.content.geolocation = False
c.content.plugins = False
c.content.pdfjs = False
c.content.images = True
c.downloads.location.directory = "~/Downloads/"
c.content.canvas_reading = True
c.content.webgl = False
c.qt.highdpi = True
c.content.blocking.method = "auto"
c.downloads.open_dispatcher = dowmload_open_script_path
c.editor.command = ["tmux", "new-window", "nvim {}"]
c.qt.force_software_rendering = "chromium"
c.qt.chromium.process_model = "process-per-site"
c.qt.chromium.low_end_device_mode = "always"
c.qt.args += [
    "disable-gpu",
    "disable-accelerated-video-decode",
    "disable-accelerated-fullscreen",
    "disable-experimental-canvas-features",
    "disable-multi-monitor-painting",
    "disable-gpu-compositing",
    "disable-accelerated-video",
    "--widevine",
]

# Keybinds
config.unbind("m")
bindings = {
    "pw": "spawn -u qute-keepassxc --key ABC1234",
    ",m": "spawn -u -m view_in_mpv {url}",
    ",M": "hint links spawn -u -m view_in_mpv {hint-url}",
    "pf": "spawn --userscript password_fill",
    "mf": "hint all spawn -d firefox {hint-url}",
    ";M": 'spawn kitty -e yt-dlp --embed-metadata \
        --embed-thumbnail -i -o "~/Videos/%(title)s.%(ext)s" -f mp4 \
        --sponsorblock-remove all --write-sub --sub-lang en \
        --convert-subs vtt {url}',
}
for key, bind in bindings.items():
    config.bind(key, bind)

# Select a file to upload
c.fileselect.handler = "external"
c.fileselect.single_file.command = ["kitty", "sh", "-c", "lf > {}"]
c.fileselect.multiple_files.command = ["kitty", "sh", "-c", "lf > {}"]

# Privacy
c.content.cookies.accept = "no-unknown-3rdparty"
c.content.cookies.store = True
c.content.webrtc_ip_handling_policy = "default-public-interface-only"


config.set("content.cookies.accept", "all", "chrome-devtools://*")
config.set("content.cookies.accept", "all", "devtools://*")
config.set("content.headers.accept_language", "", "https://matchmaker.krunker.io/*")
config.set("content.images", True, "chrome-devtools://*")
config.set("content.images", True, "devtools://*")
config.set("content.javascript.enabled", True, "chrome-devtools://*")
config.set("content.javascript.enabled", True, "devtools://*")
config.set("content.javascript.enabled", True, "chrome://*/*")
config.set("content.javascript.enabled", True, "qute://*/*")
