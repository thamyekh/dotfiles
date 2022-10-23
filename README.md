# Void Linux Setup

Run `void-installer` from the live ISO. The setup is intuitive. Things to note:
- No need to create a swap partition, especially for SSD. We will create a swapfile later.
- you will need to uncomment the wheel group the sodoers file so your user can sudo

```
reference:
https://docs.voidlinux.org/installation/live-images/guide.html
https://github.com/x0rzavi/dotfiles
```

# xbps-install -Su

After installing the base system, install the rest of our utilities.

```
xbps-install -Su polkit elogind sway wl-clipboard clipman grimshot mako foot void-repo-nonfree iwd udisks2 firefox-esr neovim psmisc brightnessctl git wget ripgrep python3 mpv playerctl mpv-mpris ffmpeg chezmoi

# these packages are specific for this laptop
xbps-install -Su linux-firmware-amd broadcom-wl-dkms mesa-dri vulkan-loader mesa-vulkan-radeon amdvlk mesa-vaapi mesa-vdpau
```

# enabling services

```
# services to enable:
elogin dbus iwd sshd

ln -s /etc/sv/<service> /var/service/
```

# iwd

Alternative to wpa_supplicant, once installed prevent iwd from removing the wireless interface in the config file.

```
[tham@void ~]$ sudo vim /etc/iwd/main.conf
...
[General]
UseDefaultInterface=true
...
```

# chezmoi

Use this to sync config to our freshly installed void linux

```
https://github.com/thamyekh/dotfiles

# don't forget scripts that are in .local/bin/
```

# fonts

fontconfig will scan the font directory below recursively, so you can create a tidy tree folder structure instead of keeping all fonts in the flat root directory. 
```
# put all of your fonts in:
/usr/share/fonts/

# keep it tidy by creating subfolders and dumping fonts in their respective folders
/usr/share/fonts/<font_format>/<font_name>/

# example
[tham@void ~]$ ls /usr/share/fonts/otf/CaskaydiaCove/
'Caskaydia Cove Nerd Font Complete Bold Italic.otf'
'Caskaydia Cove Nerd Font Complete Bold.otf'
'Caskaydia Cove Nerd Font Complete ExtraLight Italic.otf'
'Caskaydia Cove Nerd Font Complete ExtraLight.otf'
```

# swapfile

[refer to the wiki for detailed instructions for setting up a swapfile](https://github.com/thamyekh/dotfiles/wiki/swap-file)

# python

```
# install pip
https://pip.pypa.io/en/stable/installation/
```

# neovim

```
# See this repo to set up neovim as an IDE
https://github.com/LunarVim/nvim-basic-ide

# set default editor
[tham@void ~]$ sudo xbps-alternatives -s neovim -g vi
```

# gtk

```
dependencies:
[tham@void ~]$ sudo xbps-instal -Su gsettings-desktop-schemas sassc

https://github.com/vinceliuice/Colloid-gtk-theme
see the current theme
gsettings get org.gnome.desktop.interface gtk-theme
replace gtk-theme with the necessary setting in your sway config

reference: https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland#setting-values-in-gsettings

# manually setting theme
gsettings set org.gnome.desktop.interface gtk-theme <theme-name>
```

# swaywm

## debugging
Start sway in verbose mode (-V) and redirecting the log output to a file
```
[tham@void ~]$ sway -V > debug.log
```

# audio

[refer to the wiki for detailed instructions for setting up pipewire](https://github.com/thamyekh/dotfiles/wiki/pipewire)

# video

to get mpv working with playerctl (keyboard media keys):
```
[tham@void ~]$ sudo xbps-install -Su mpv-mpris
[tham@void ~]$ sudo mkdir /etc/mpv/scripts
[tham@void ~]$ sudo ln -s /usr/lib/mpv-mpris/mpris.so /etc/mpv/scripts/mpris.so

# reference:
https://www.reddit.com/r/voidlinux/comments/v64x2p/comment/ic5yi9e/?utm_source=share&utm_medium=web2x&context=3
```

# firefox (ESR)

run firefox-wayland; sway shortcut `Mod4+b`

`https://ffprofile.com/`

# bemenu

This is our application launcher. Sway will call `custom-launcher.sh` from `~/.local/bin/`

Alternatives:
- tofi
- onagre

# waybar temperature

[refer to the wiki for detailed instructions for setting up the temperature module on waybar](https://github.com/thamyekh/dotfiles/wiki/temperature)

# udisksctl
```
# listing available devices
[tham@void ~]$ udisksctl status
MODEL                     REVISION  SERIAL               DEVICE
--------------------------------------------------------------------------
...   
USB SanDisk 3.2Gen1       1.00      00019426031221152112 sdb 

# mount usb at /dev/sdb
[tham@void ~]$ udisksctl mount -b /dev/sdb1

# unmount usb at /dev/sdb
[tham@void ~]$ udisksctl unmount -b /dev/sdb1

# mount location (usually)
/run/media/<user>/<device-label>
```

# vnc
```
xbps-install -Su zerotier-one wayvnc
```

## running wayvnc in headless mode

Create our vnc "stager" in `~/.config/sway/`
```vnc.txt
exec wayvnc <zerotier_ip> 5900
```

Create a `vnc-sway` script and store it in `.local/bin/`
```
#!/bin/env dash
cat ~/.config/sway/config ~/.config/sway/vnc.txt > ~/.config/sway/vnc.config
env WLR_BACKENDS=headless WLR_LIBINPUT_NO_DEVICES=1 sway -c ~/.config/sway/vnc.config
```

Don't forget to `chmod +x vnc-sway`.

# optional packages
```
yt-dlp : youtube video downloader (make sure you have ffmpeg installed)
```

