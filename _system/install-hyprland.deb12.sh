#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
#
# install hyprland + deps on debian 12

if [[ "$1" && "$1" == "--no-deps" ]]; then
    _noDeps="set"
fi

_hyprlandDir="${HOME}/git/hyprland-build"

_hyprlandVersion="${HYPRINSTALL_HYPRLAND_VERSION:-"0.40.0"}"
_waylandProtocolsVersion="${HYPRINSTALL_WAYLAND_PROTOCOLS_VERSION:-"1.32"}"
_waylandVersion="${HYPRINSTALL_WAYLAND_VERSION:-"1.23.0"}"
_libdisplayInfoVersion="${HYPERINSTALL_LIBDISPLAY_INFO_VERSION:-"0.1.1"}"
_libinputVersion="${HYPRINSTALL_LIBINPUT_VERSION:-"1.24.0"}"
_libliftoffVersion="${HYPRINSTALL_LIBLIFTOFF_VERSION:-"0.4.1"}"
_sddmVersion="${HYPRINSTALL_SDDM_VERSION:-"0.20.0"}"

if [[ "$1" && "$1" =~ "-h"|"--help" ]]; then
    cat << _EOH1
usage: $(basename "$0") [-h|--help] [--no-deps]

    --no-deps            Install just hyprland, no debian-needed dependencies.
    -h --help            Show this help.

environment variables:
    HYPRLAND_VERSION           = ${_hyprlandVersion}
-- deps:
    WAYLAND_PROTOCOLS_VERSION  = ${_waylandProtocolsVersion}
    WAYLAND_VERSION            = ${_waylandVersion}
    LIBDISPLAY_INFO_VERSION    = ${_libdisplayInfoVersion}
    LIBINPUT_VERSION           = ${_libinputVersion}
    LIBLIFTOFF_VERSION         = ${_libliftoffVersion}
_EOH1
exit
fi

##--- install available deps in deb repos ---##
sudo apt-get install -y \
    meson \
    wget \
    build-essential \
    ninja-build \
    cmake-extras \
    cmake \
    gettext \
    gettext-base \
    fontconfig \
    libfontconfig-dev \
    libffi-dev \
    libxml2-dev \
    libdrm-dev \
    libxkbcommon-x11-dev \
    libxkbregistry-dev \
    libxkbcommon-dev \
    libpixman-1-dev \
    libudev-dev \
    libseat-dev \
    seatd \
    libxcb-dri3-dev \
    libvulkan-dev \
    libvulkan-volk-dev \
    vulkan-validationlayers-dev \
    libvkfft-dev \
    libgulkan-dev \
    libegl-dev \
    libgles2 \
    libegl1-mesa-dev \
    glslang-tools \
    libinput-bin \
    libinput-dev \
    libxcb-composite0-dev \
    libavutil-dev \
    libavcodec-dev \
    libavformat-dev \
    libxcb-ewmh2 \
    libxcb-ewmh-dev \
    libxcb-present-dev \
    libxcb-icccm4-dev \
    libxcb-render-util0-dev \
    libxcb-res0-dev \
    libxcb-xinput-dev \
    libgbm-dev \
    xdg-desktop-portal-wlr \
    hwdata \
    libgtk-3-dev \
    libsystemd-dev \
    edid-decode \
    extra-cmake-modules \
    libpam0g-dev \
    qtbase5-dev \
    qtdeclarative5-dev \
    qttools5-dev \
    python3-docutils \
    check

mkdir -p "${_hyprlandDir}"
pushd "${_hyprlandDir}" || exit 1

##--- download sources ---##
wget "https://github.com/hyprwm/Hyprland/releases/download/v${_hyprlandVersion}/source-v${_hyprlandVersion}.tar.gz" \
    -O "source-v${_hyprlandVersion}.tar.gz" && \
tar -xvzf "source-v${_hyprlandVersion}.tar.gz"

if [ -z "${_noDeps}" ]; then
    #-- deps --#
    wget "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/${_waylandProtocolsVersion}/downloads/wayland-protocols-${_waylandProtocolsVersion}.tar.xz" \
        -O "wayland-protocols-${_waylandProtocolsVersion}.tar.xz" && \
    tar -xvJf "wayland-protocols-${_waylandProtocolsVersion}.tar.xz"

    wget "https://gitlab.freedesktop.org/wayland/wayland/-/releases/${_waylandVersion}/downloads/wayland-${_waylandVersion}.tar.xz" \
        -O "wayland-${_waylandVersion}.tar.xz" && \
    tar -xvJf "wayland-${_waylandVersion}.tar.xz"

    wget "https://gitlab.freedesktop.org/emersion/libdisplay-info/-/releases/${_libdisplayInfoVersion}/downloads/libdisplay-info-${_libdisplayInfoVersion}.tar.xz" \
        -O "libdisplay-info-${_libdisplayInfoVersion}.tar.xz" && \
    tar -xvJf "libdisplay-info-${_libdisplayInfoVersion}.tar.xz"

    wget "https://gitlab.freedesktop.org/libinput/libinput/-/archive/${_libinputVersion}/libinput-${_libinputVersion}.tar.gz" \
        -O "libinput-${_libinputVersion}.tar.gz" && \
    tar -xvzf "libinput-${_libinputVersion}.tar.gz"

    wget "https://gitlab.freedesktop.org/emersion/libliftoff/-/archive/v${_libliftoffVersion}/libliftoff-v${_libliftoffVersion}.tar.gz" \
        -O "libliftoff-v${_libliftoffVersion}.tar.gz" && \
    tar -xvzf "libliftoff-v${_libliftoffVersion}.tar.gz"

    #-- sddm --#
    wget "https://github.com/sddm/sddm/archive/refs/tags/v${_sddmVersion}.tar.gz" \
        -O "sddm-v${_sddmVersion}.tar.gz" && \
    tar -xvzf "sddm-v${_sddmVersion}.tar.gz"

    ##--- build deps ---##

    #-- build wayland
    pushd "wayland-${_waylandVersion}" || exit 2

    meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/ && ninja -C build/
    sudo ninja -C build/ install

    popd || exit 1

    #-- build wayland-protocols
    pushd "wayland-protocols-${_waylandProtocolsVersion}" || exit 3

    meson setup --prefix=/usr --buildtype=release build/ && ninja -C build/
    sudo ninja -C build/ install

    popd || exit 1

    #-- build libdisplay-info
    pushd "libdisplay-info-${_libdisplayInfoVersion}" || exit 4

    meson setup --prefix=/usr --buildtype=release build/ && ninja -C build/
    sudo ninja -C build/ install

    popd || exit 1

    #-- build libinput
    pushd "libinput-${_libinputVersion}" || exit 5

    sudo ln -s /usr/include/locale.h /usr/include/xlocale.h

    meson setup --prefix=/usr --buildtype=release -Ddocumentation=false build/ && ninja -C build/
    sudo ninja -C build/ install

    popd || exit 1

    #-- build libliftoff
    pushd "libliftoff-v${_libliftoffVersion}" || exit 6

    meson setup --prefix=/usr --buildtype=release build/ && ninja -C build/
    sudo ninja -C build/ install

    popd || exit 1

    #-- build sddm
    mkdir "sddm-${_sddmVersion}/build/" && \
    pushd "sddm-${_sddmVersion}/build/" || exit 7

    cmake .. \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_BUILD_TYPE=Release \
        -DENABLE_JOURNALD=ON \
        -DBUILD_MAN_PAGES=ON

    make \
        && sudo make install

    if [ -z "$(getent passwd sddm)" ]; then
        sudo useradd \
            --system \
            --create-home \
            --shell "/sbin/nologin" \
            --home-dir "/var/lib/sddm" \
            --comment "Simple Desktop Display Manager" \
            sddm
    fi

    popd || exit 1
fi

##--- build hyprland ---##
chmod a+rw hyprland-source
pushd hyprland-source || exit 10

make all && \
    sudo make PREFIX=/usr install

popd || exit 1
