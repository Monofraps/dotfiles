#!/bin/sh

ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

CURRENT_USER=$USER

YUM_COMMAND="dnf"

function info() {
    echo -e "\n$COL_CYAN[dot] ⇒ $COL_RESET"$1""
}

function ok() {
    echo -e "$COL_GREEN[ok]$COL_RESET"
}

function error() {
    echo -e "$COL_RED[error]$COL_RESET \n"$1
}

function action() {
    echo -en "$COL_YELLOW ⇒$COL_RESET $1..."
}

function require_yum() {
    action "$YUM_COMMAND install $1"
    STD_ERR="$(sudo $YUM_COMMAND install -q -y $1 2>&1 > /dev/null)"
    if [ $? != "0" ]; then
        error "failed to install $1! aborting..."
        error $STD_ERR
        exit -1
    fi

    ok
}

function require_yum_group() {
    action "$YUM_COMMAND groupinstall -y $1"

    STD_ERR="$(sudo $YUM_COMMAND groupinstall -q -y \"$1\" 2>&1 > /dev/null)"
    if [ $? != "0" ]; then
        error "failed to install group $1! aborting..."
        error $STD_ERR
        exit -1
    fi

    ok
}

# Install a few things
sudo -v

info "Installing base packages..."
require_yum stow
require_yum_group "Development Tools"
require_yum automake
require_yum rxvt-unicode
require_yum zsh
require_yum vim-enhanced
require_yum libtool
require_yum gcc-c++

# bspwm build
info "Installing bspwm development packages..."
require_yum libxcb-devel 
require_yum xcb-util-devel 
require_yum xcb-util-wm 
require_yum xcb-util-wm-devel

# sxhkd build
info "Installing sxhkd development packages..."
require_yum xcb-util-keysyms 
require_yum xcb-util-keysyms-devel

info "Installing tiling wm utility packages..."
require_yum dmenu
require_yum feh

# compton build
info "Installing compton development packages..."
require_yum libX11-devel
require_yum libXcomposite-devel
require_yum libXdamage-devel
require_yum libXfixes-devel
require_yum libXext-devel
require_yum libXrender-devel
require_yum libXrandr-devel
require_yum libXinerama-devel
require_yum libconfig-devel
require_yum libdrm-devel
require_yum libGL-devel
require_yum dbus-devel
require_yum pcre-devel
require_yum asciidoc

# Build bspwm & sxhkd
cd sources

cd bspwm
info "bspwm..."

action "make"
make -s;ok

action "make install"
sudo PREFIX=/usr make -s install;ok

action "Installing desktop description"
sudo cp contrib/freedesktop/bspwm.desktop /usr/share/xsessions/bspwm.desktop;ok

action "Installing session init script"
sudo cp contrib/freedesktop/bspwm-session /usr/bin/bspwm-session;ok
cd .. # sources/bspwm

cd sxhkd
info "sxhkd"

action "make"
make -s;ok

action "make install"
sudo PREFIX=/usr make -s install;ok
cd .. # sources/sxhkd

cd compton
info "compton"

action "make"
make -s;ok

action "make install"
sudo PREFIX=/usr make -s install;ok
cd .. # sources/compton

cd .. # sources

info "System settings..."

action "Setting login shell to zsh"
sudo chsh -s /bin/zsh $CURERNT_USER 2> /dev/null > /dev/null;ok
