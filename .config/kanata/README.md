# Kanata Setup - Arch Linux

Quick setup guide for Kanata on Arch Linux.

## Installation

```bash
# Install from AUR
paru -S kanata

# Verify
kanata --version
```

## Permissions

```bash
# Delete any existing input and uinput groups
sudo groupdel uinput 2>/dev/null

# Create uinput group if not exists
sudo groupadd --system uinput

# Add user to input and uinput groups
sudo usermod -a -G input $USER
sudo usermod -a -G uinput $USER
```

## Udev Rules

```bash
# Create udev rule for uinput
sudo tee /etc/udev/rules.d/99-input.rules > /dev/null << 'EOF'
KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
EOF

# Reload udev rules
sudo udevadm control --reload-rules && sudo udevadm trigger
```

## Configuration

```bash
# Create config directory
mkdir -p ~/.config/kanata

# Create config.kbd with your key mappings
# Example: swap CapsLock and ESC
cat > ~/.config/kanata/config.kbd << 'EOF'
(defcfg
  process-unmapped-keys yes
  log-layer-changes yes
)

(defsrc
  esc  1    2    3    4    5    6    7    8    9    0    -    =    bspc
  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
  caps a    s    d    f    g    h    j    k    l    ;    '    ret
  lsft z    x    c    v    b    n    m    ,    .    /    rsft
  lctl lmet lalt spc  ralt rmet rctl
)

(deflayer base
  caps 1    2    3    4    5    6    7    8    9    0    -    =    bspc
  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
  esc  a    s    d    f    g    h    j    k    l    ;    '    ret
  lsft z    x    c    v    b    n    m    ,    .    /    rsft
  lctl lmet lalt spc  ralt rmet rctl
)
EOF

# Validate
kanata --check -c ~/.config/kanata/config.kbd
```

## Load Module

```bash
# Load uinput module (run once)
sudo modprobe uinput

# Make it persistent (optional)
echo "uinput" | sudo tee /etc/modules-load.d/uinput.conf
```

## Run

```bash
# Manual test
kanata -c ~/.config/kanata/config.kbd

# Debug mode
kanata -d -c ~/.config/kanata/config.kbd

# Emergency exit: Ctrl + Space + Escape
```

## Auto-start (systemd)

Based on [official documentation](https://github.com/jtroo/kanata/blob/main/docs/setup-linux.md).

### Create systemd service

```bash
# Create service directory
mkdir -p ~/.config/systemd/user

# Create service file
cat > ~/.config/systemd/user/kanata.service << 'EOF'
[Unit]
Description=Kanata keyboard remapper
Documentation=https://github.com/jtroo/kanata

[Service]
Environment=PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin
Type=simple
ExecStart=/usr/bin/sh -c 'exec $$(which kanata) --cfg $${HOME}/.config/kanata/config.kbd'
Restart=no

[Install]
WantedBy=default.target
EOF
```

**Notes:**
- Update `/usr/bin/sh` path if needed: check with `which sh`
- If `which kanata` returns `~/.cargo/bin/kanata`, add that path to Environment
- `$$` is the correct escape for `$` in systemd (not single `$`)

### Enable and start service

```bash
# Reload systemd configuration
systemctl --user daemon-reload

# Enable service (starts on user login)
systemctl --user enable kanata.service

# Start service immediately
systemctl --user start kanata.service

# Check status
systemctl --user status kanata.service

# View logs (follow mode)
journalctl --user -u kanata.service -f

# View last 50 log lines
journalctl --user -u kanata.service -n 50
```

## References

- [Official Docs](https://github.com/jtroo/kanata)
- [Config Guide](https://github.com/jtroo/kanata/blob/main/docs/config.adoc)
- [AUR Package](https://aur.archlinux.org/packages/kanata)
- [Unix Layouts on any Keyboard with Kanata](https://www.johnling.me/blog/Unix-Keyboards)

