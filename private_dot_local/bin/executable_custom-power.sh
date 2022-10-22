#!/bin/env dash

# Reference: https://github.com/x0rzavi
# Theme: Catppuccin

killall -q bemenu

# Variables
black='#1E1E2E'
sky='#89DCEB'
mauve='#CBA6F7' 
peach='#FAB387'
green='#A6E3A1'
options=' Cancel\n鈴 Suspend\n Lock\n Logout\n Reboot\n Shutdown'

selected=$(printf "${options}" \
	| bemenu \
	--ignorecase \
	--list 6 \
	--prefix '' \
	--prompt 'POWERMENU ' \
	--fork \
	--line-height 25 \
	--cw 3 \
	--fn 'CaskaydiaCove Nerd Font Bold' \
	--tb "${black}" \
	--tf "${peach}" \
	--fb "${black}" \
	--ff "${mauve}" \
	--nb "${black}" \
	--nf "${peach}" \
	--hb "${black}" \
	--hf "${green}" \
	--ab "${black}" \
	--af "${sky}" \
	--bdr "${mauve}" \
	--cb "${black}" \
	--cf "${mauve}" )

case "${selected}" in
	(*Cancel*) :;;
	(*Suspend*) 
		# uncomment after issue is resolved [https://github.com/elogind/elogind/issues/208]
		#notify-send --expire-time=3000 "鈴 Suspending in 5 seconds..." && \
    #sleep 5 && \
		#gtklock && \
		#sleep 1 && \
		#loginctl suspend;;  
    sudo zzz;;
	(*Lock*) gtklock;;
	(*Logout*) swaynag -t warning -m 'Exit sway?' -B 'Yes' 'swaymsg exit';;
	(*Shutdown*) 
		notify-send --expire-time=3000 " Shutting down in 5 seconds..." && \
		sleep 5 && \
		loginctl poweroff;;
	(*Reboot*)
		notify-send --expire-time=3000 " Rebooting in 5 seconds..." && \
		sleep 5	&& \
		loginctl reboot;;
esac
