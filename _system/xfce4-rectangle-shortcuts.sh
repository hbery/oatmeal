#!/bin/bash

xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Super>Enter" -t string -s "exo-open --launch TerminalEmulator"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Super>Space" -t string -s "rofi -no-lazy-grab -show drun -modi run,drun,window -theme /home/at/.config/rofi/launcher/spotlight-dark"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Super>b" -t string -s "exo-open --launch WebBrowser"

xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Primary><Alt>Up" -t string -s "tile_up_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Primary><Alt>Down" -t string -s "tile_down_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Primary><Alt>Right" -t string -s "tile_right_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Primary><Alt>Left" -t string -s "tile_left_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Primary><Alt>Enter" -t string -s "fullscreen_key"

xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Primary><Alt>u" -t string -s "tile_up_right_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Primary><Alt>j" -t string -s "tile_down_right_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Primary><Alt>k" -t string -s "tile_down_left_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Primary><Alt>i" -t string -s "tile_up_left_key"

xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Primary><Alt>+" -t string -s "tile_up_left_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Primary><Alt>-" -t string -s "tile_up_left_key"

# workspaces
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Super><Primary>Up" -t string -s "up_workspace_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Super><Primary>Down" -t string -s "down_workspace_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Super><Primary>Right" -t string -s "right_workspace_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Super><Primary>Left" -t string -s "left_workspace_key"

xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Super><Shift><Primary>Up" -t string -s "move_window_up_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Super><Shift><Primary>Down" -t string -s "move_window_down_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Super><Shift><Primary>Right" -t string -s "move_window_right_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Super><Shift><Primary>Left" -t string -s "move_window_left_key"

# create functions which does not exist
mkdir -p "${HOME}/.xfce_scripts"

cat << _EOH1 > "${HOME}/.xfce_scripts/tile_center_key"
#!/bin/bash

IFS='x' read _screen_width _screen_height < <(xdpyinfo | grep dimensions | grep -o '[0-9x]*' | head -n1)

_window_width=$(xdotool getactivewindow getwindowgeometry --shell | sed -nr 's/WIDTH=(.*)/\1/p')
_window_height=$(xdotool getactivewindow getwindowgeometry --shell | sed -nr 's/HEIGHT=(.*)/\1/p')

_new_position_x=$((_screen_width/2-_window_width/2))
_new_position_y=$((_screen_height/2-_window_height/2))

xdotool getactivewindow windowmove "${_new_position_x}" "${_new_position_y}"
_EOH1

chown 755 "${HOME}/.xfce_scripts/tile_center_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Primary><Alt>c" -t string -s "tile_center_key"

cat << _EOH2 > "${HOME}/.xfce_scripts/tile_resize_key"
#!/bin/bash

IFS='x' read _screen_width _screen_height < <(xdpyinfo | grep dimensions | grep -o '[0-9x]*' | head -n1)

_window_width=$(xdotool getactivewindow getwindowgeometry --shell | sed -nr 's/WIDTH=(.*)/\1/p')
_window_height=$(xdotool getactivewindow getwindowgeometry --shell | sed -nr 's/HEIGHT=(.*)/\1/p')

if [ "$1" = "up" ]; then
    _new_window_width=$((_window_width+10))
    _new_window_height=$((_window_height+10))
elif [ "$2" = "down" ]; then
    _new_window_width=$((_window_width-10))
    _new_window_height=$((_window_height-10))
else
    exit 1
fi

xdotool getactivewindow windowsize "${_window_width}" "${_window_height}"
_EOH2

chown 755 "${HOME}/.xfce_scripts/tile_resize_key"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Primary><Alt>-" -t string -s "tile_resize_key down"
xfconf-query -c xfce4-keyboard-shortcuts -n -p "/xfwm4/custom/<Primary><Alt>=" -t string -s "tile_resize_key up"
