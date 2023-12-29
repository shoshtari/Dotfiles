# Adding Persian layout
setxkbmap -layout us,ir -option "grp:win_space_toggle"

# Wallpaper
# feh --bg-fill /home/mpc/Pictures/Wallpapers/Rosette_Insley_3424.jpg
feh --bg-fill $(cat ~/.config/bspwm/wallpaper)

#Picom 
picom -f &

# Flameshot
flameshot &

# Notification Manager
/usr/bin/dunst &

# Polybar
/home/mpc/.config/bspwm/polybar/launch.sh

# Conky 
# conky &

# Guake
yakuake &

# V2ray
v2raya --lite &

eval $(ssh-agent)

# handling kde apps
export XDG_CURRENT_DESKTOP=KDE
export XDG_SESSION_DESKTOP=KDE


