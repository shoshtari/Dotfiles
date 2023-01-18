# Adding Persian layout
setxkbmap -layout us,ir -option "grp:win_space_toggle"

# Wallpaper
feh --bg-fill /home/mpc/Pictures/Wallpapers/arch-linux-wallpaper.png

#Picom 
picom -f &

# Flameshot
flameshot &

# Notification Manager
/usr/bin/dunst &

# Polybar
/home/mpc/.config/bspwm/polybar/launch.sh

# Conky 
conky &

# Guake
guake &
