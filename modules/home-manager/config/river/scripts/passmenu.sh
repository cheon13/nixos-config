#!/usr/bin/env bash

source ~/.config/river/matugen/bemenu-colors.sh

shopt -s nullglob globstar

if [[ -n $WAYLAND_DISPLAY ]]; then
	dmenu="bemenu"
	#dmenu=dmenu-wl
elif [[ -n $DISPLAY ]]; then
	dmenu=dmenu
else
	echo "Error: No Wayland or X11 display detected" >&2
	exit 1
fi

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

password=$(printf '%s\n' "${password_files[@]}" | "$dmenu" --prompt "Pass" -i -W 0.3 -c -l 20 --fn JetBrainsMono 14 --fb $background --ff $foreground --nb $background --nf $foreground --tb $primary --hb $background --tf $on_primary --hf $primary  --af $foreground --ab $background -B 0 --bdr $foreground "$@")

[[ -n $password ]] || exit

pass show -c "$password" 2>/dev/null

