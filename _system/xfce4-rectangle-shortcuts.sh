#!/bin/bash

_scriptsDir="${XDG_DATA_HOME:-"${HOME}/.local"}/sbin"

# ---------------------------------------------------- * default applications *
echo "*** Setting Application shortcuts"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/commands/custom/<Super>Enter" -t string -s "exo-open --launch TerminalEmulator"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/commands/custom/<Super>Space" -t string -s "rofi -no-lazy-grab -show drun -modi run,drun,window -theme ${XDG_CONFIG_HOME:-"${HOME}/.config"}/rofi/launcher/spotlight-dark"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/commands/custom/<Super>b" -t string -s "exo-open --launch WebBrowser"

# ------------------------------------------------------------------ * tiling *
echo "*** Setting tiling shortcuts"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Primary><Alt>Up" -t string -s "tile_up_key"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Primary><Alt>Down" -t string -s "tile_down_key"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Primary><Alt>Right" -t string -s "tile_right_key"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Primary><Alt>Left" -t string -s "tile_left_key"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Primary><Alt>Return" -t string -s "maximize_window_key"

xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Primary><Alt>u" -t string -s "tile_up_right_key"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Primary><Alt>j" -t string -s "tile_down_right_key"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Primary><Alt>k" -t string -s "tile_down_left_key"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Primary><Alt>i" -t string -s "tile_up_left_key"

# -------------------------------------------------------------- * workspaces *
echo "*** Setting workspaces shortcuts"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Super><Primary>Up" -t string -s "up_workspace_key"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Super><Primary>Down" -t string -s "down_workspace_key"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Super><Primary>Right" -t string -s "right_workspace_key"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Super><Primary>Left" -t string -s "left_workspace_key"

xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Super><Shift><Primary>Up" -t string -s "move_window_up_key"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Super><Shift><Primary>Down" -t string -s "move_window_down_key"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Super><Shift><Primary>Right" -t string -s "move_window_right_key"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/xfwm4/custom/<Super><Shift><Primary>Left" -t string -s "move_window_left_key"

# create functions which do not exist
mkdir -p "${_scriptsDir}"

echo "*** Setting tiling center shortcut"
cat << _EOH1 > "${_scriptsDir}/xfce4_tile_center_key"
#!/bin/bash

IFS='x' read _screen_width _screen_height < <(xdpyinfo | grep dimensions | grep -o '[0-9x]*' | head -n1)

_window_width=\$(xdotool getactivewindow getwindowgeometry --shell | sed -nr 's/WIDTH=(.*)/\1/p')
_window_height=\$(xdotool getactivewindow getwindowgeometry --shell | sed -nr 's/HEIGHT=(.*)/\1/p')

_new_position_x=\$((_screen_width/2-_window_width/2))
_new_position_y=\$((_screen_height/2-_window_height/2))

xdotool getactivewindow windowmove "\${_new_position_x}" "\${_new_position_y}"
_EOH1

chown ${USER}:${USER} "${_scriptsDir}/xfce4_tile_center_key"
chmod 755 "${_scriptsDir}/xfce4_tile_center_key"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/commands/custom/<Primary><Alt>c" -t string -s "${_scriptsDir}/xfce4_tile_center_key"
echo "*** Setting resize shortcuts"
cat << _EOH2 > "${_scriptsDir}/xfce4_tile_resize_key"
#!/bin/bash

IFS='x' read _screen_width _screen_height < <(xdpyinfo | grep dimensions | grep -o '[0-9x]*' | head -n1)

_window_width=\$(xdotool getactivewindow getwindowgeometry --shell | sed -nr 's/WIDTH=(.*)/\1/p')
_window_height=\$(xdotool getactivewindow getwindowgeometry --shell | sed -nr 's/HEIGHT=(.*)/\1/p')

if [ "\$1" = "up" ]; then
    _new_window_width=\$((_window_width+20))
    _new_window_height=\$((_window_height+20))
elif [ "\$1" = "down" ]; then
    _new_window_width=\$((_window_width-20))
    _new_window_height=\$((_window_height-20))
else
    exit 1
fi

xdotool getactivewindow windowsize "\${_new_window_width}" "\${_new_window_height}"
_EOH2

chown ${USER}:${USER} "${_scriptsDir}/xfce4_tile_resize_key"
chmod 755 "${_scriptsDir}/xfce4_tile_resize_key"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/commands/custom/<Primary><Alt>minus" -t string -s "${_scriptsDir}/xfce4_tile_resize_key down"
xfconf-query -c xfce4-keyboard-shortcuts -nv -p "/commands/custom/<Primary><Alt>equal" -t string -s "${_scriptsDir}/xfce4_tile_resize_key up"
