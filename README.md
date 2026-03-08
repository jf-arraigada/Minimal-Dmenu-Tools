# Minimal-Dmenu-Tools

Collection of small **dmenu-like utilities** for Linux.

These tools provide simple interactive menus for common desktop tasks such as WiFi management, Bluetooth devices, audio control, power options and more.

Designed for minimal environments like **sway**, **hyprland**, **dwl**, etc.

> [!NOTE]
> Most tools work on X11, except `clipboard-menu` and possibly `audio-menu`.

> [!IMPORTANT]
> These tools are designed to work with `bemenu`.  
> Other dmenu-like launchers can also be used, but you may need to adjust a few lines in the scripts.  
> The `install.sh` script will point out where those changes should be made.

---

## Features

* WiFi menu
* Bluetooth menu
* Audio device menu
* Power menu
* Energy menu
* Process kill menu
* Clipboard menu
* Note menu

All tools are designed to be **simple, scriptable and lightweight**.

---

## Installation

Clone the repository:

```bash
git clone https://github.com/jf-arraigada/Minimal-Dmenu-Tools.git
cd Minimal-Dmenu-Tools
```

Run the installer:

```bash
./install.sh
```

This will install the scripts into:

```
~/.minimal-dmenu-tools
```

---

## Requirements

Some tools depend on external programs.

Common dependencies include:

* dmenu-like (bemenu, rofi, etc)
* nmcli
* bluetoothctl
* pactl
* systemctl
* wl-copy / wl-paste

The installer will attempt to check for required commands.

---

## Usage

After installation you can run the tools directly:

* wifi-menu
* bluetooth-menu
* audio-menu
* power-menu

Bind them to your window manager keys if desired.

Example (sway):

```
MOD + w -> wifi-menu
MOD + b -> bluetooth-menu
MOD + p -> power-menu
```

---

## Philosophy

These scripts aim to be:

* simple
* minimal
* dependency-light

Everything is written in **POSIX shell** where possible.

---

## License

MIT License

