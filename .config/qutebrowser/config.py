from PyQt5.QtCore import QUrl
from qutebrowser.api import interceptor, message
from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer
from urllib.parse import urljoin
import operator
import re
config: ConfigAPI = config
c: ConfigContainer = c
dowmload_open_script_path = "/usr/share/qutebrowser/userscripts/open_download"


# REDIRECT CONFIG
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
    # "youtube.com": operator.methodcaller('setHost', 'piped.video'),
    # "www.youtube.com": operator.methodcaller('setHost', 'piped.video'),
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


# UI
c.fonts.default_family = [
    "Terminess Nerd Font",
    "Ubuntu Nerd Font",
    "Noto Sans CJK JP",
    "Noto Color Emoji"
]
c.fonts.default_size = "15px"
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.grayscale.all = True
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.policy.images = "never"
c.colors.webpage.darkmode.policy.page = "always"
c.completion.shrink = True
c.completion.use_best_match = True
c.statusbar.widgets = ["keypress", "progress", "url", "scroll"]
c.tabs.title.format = "{index}: {audio}{current_title}"
c.tabs.title.format_pinned = "{index}: {audio}{current_title}"
c.tabs.select_on_remove = "last-used"
c.url.default_page = "https://duckduckgo.com/"
c.url.start_pages = ["https://duckduckgo.com/"]

# GENERAL
c.input.insert_mode.auto_load = True
c.auto_save.session = False
c.content.prefers_reduced_motion = True
c.content.xss_auditing = True
c.content.javascript.modal_dialog = True
c.content.javascript.can_access_clipboard = True
c.content.javascript.can_open_tabs_automatically = True
c.downloads.location.prompt = False
c.tabs.mousewheel_switching = False
c.content.autoplay = False
c.content.plugins = True
c.content.pdfjs = False
c.downloads.location.directory = "~/Downloads/"
c.content.canvas_reading = False
c.content.webgl = False
c.qt.highdpi = True
c.downloads.open_dispatcher = dowmload_open_script_path
c.editor.command = ["kitty", "-e", "nvim", "{file}"]
c.qt.force_software_rendering = "chromium"
c.qt.args += [
    "ignore-gpu-blacklist",
    "--widevine",
]

#c.aliases = {'q': 'quit', 'w': 'session-save', 'wq': 'quit --save'}
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
    'kitty', '--class', 'lf,lf', '-e', 'lf', '-last-dir-path', '~/', '-selection-path', '{}'
]
c.fileselect.multiple_files.command = [
    'kitty', '--class', 'lf,lf', '-e', 'lf', '-last-dir-path', '~/', '-selection-path', '{}'
]

config.load_autoconfig(False)
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
config.set('content.cookies.accept', 'all', 'devtools://*')
config.set('content.headers.accept_language', '', 'https://matchmaker.krunker.io/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:90.0) Gecko/20100101 Firefox/90.0', 'https://accounts.google.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:54.0) Gecko/20100101 Firefox/54.0')
config.set('content.headers.user_agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3')
config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')
