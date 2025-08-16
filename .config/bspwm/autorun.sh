# Adding Persian layout
setxkbmap -layout us,ir -option "grp:win_space_toggle"

# Wallpaper
feh --bg-fill $(cat ~/.config/bspwm/wallpaper)

#Picom 
picom -f &

# Flameshot
flameshot &

# Notification Manager
/usr/bin/dunst &

# Polybar
/home/morteza/.config/bspwm/polybar/launch.sh

# Conky 
# conky &

# Guake
# yakuake &

# V2ray

eval $(ssh-agent)

# handling kde apps
export XDG_CURRENT_DESKTOP=KDE
export XDG_SESSION_DESKTOP=KDE


# auto open apps 

bspc rule -a firefox --one-shot desktop=^8 && firefox --new-window chatgpt.com
function nekoray(){
	sleep 1
	/home/morteza/applications/nekoray/nekoray 
}
nohup $(nekoray) & 
nohup telegram-desktop &
nohup conky &
