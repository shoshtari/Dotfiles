#!/usr/bin/sh

#--blur 10
/usr/bin/i3lock \
--blur 0 \
-k \
--indicator \
--radius 100 \
--ring-color 013700 \
--inside-color DCF4E2 \
--keyhl-color 1AFF23 \
--separator-color 00BF30 \
--verif-color aaaaff \
--wrong-color ff9999 \
--time-color 006018 \
--date-color 009625 \
--keylayout 2 \
--time-font monofur \
--date-font monofur \
--layout-font monofur \
--time-size 32 \
--date-size 18 \
--layout-size 20 \
--line-color 013700 &

sleep 0.5 && xset dpms force suspend
