#!/bin/bash
start_green="\033[92m"
end_green="\033[39m"

current=${PWD}

mkdir -p ~/.config
mkdir -p ~/.local/share/applications
mkdir -p ~/Pictures
mkdir -p ~/.local/share/fonts

echo -e "\n${start_green} Installing dependencies and fonts...${end_green}"

sudo add-apt-repository ppa:samoilov-lex/sway
sudo add-apt-repository ppa:ubuntu-mozilla-daily/ppa

sudo apt install \
    brightnessctl \
    grim \
    slurp \
    sway \
    sway-backgrounds \
    swaybg \
    swayidle \
    swaylock \
    xdg-desktop-portal-wlr \
    wl-clipboard \
    libmpdclient2 \
    libnl-3-200 \
    playerctl \
    rofi \
    firefox-trunk

cp fonts/* ~/.local/share/fonts

echo -e "\n${start_green} Fixing brightness controls for ${USER}...${end_green}"

sudo cp 90-brightnessctl.rules /etc/udev/rules.d/
sudo usermod -a -G video $(whoami)

echo -e "\n${start_green} Fixing snap apps in menu... ${end_green}"

snap_apps_fix=/etc/profile.d/apps-bin-path.sh
if [[ ! -f "${snap_apps_fix}" ]]; then
    sudo cp snap-apps-fix.sh ${snap_apps_fix}
fi

echo -e "\n${start_green} Linking sway config folders into ~/.config... ${end_green}"

folders_to_linky=("sway" "waybar" "kanshi" "rofi" "icons")
for folder in ${folders_to_linky[@]}; doQ
    if [[ ! -e "${HOME}/.config/${folder}" ]]; then
        ln -s ${PWD}/${folder}/ "${HOME}/.config/${folder}"
    fi
done

# Backgrounds
ln -s ${current}/backgrounds ~/Pictures/

# Make FF wayland default (workaround to https://bugzilla.mozilla.org/show_bug.cgi?id=1508803)
cp firefox-wayland.desktop ~/.local/share/applications
cp firefox-nightly.desktop ~/.local/share/applications
xdg-settings set default-web-browser firefox-nightly.desktop

# Scripts
ln -s ${current}/brightness-notification.sh ~/bin/
ln -s ${current}/audio-notification.sh ~/bin/
ln -s ${current}/notify-send.sh/notify-*.sh ~/bin/
