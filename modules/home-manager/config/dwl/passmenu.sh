#!/usr/bin/env bash

source ~/.config/dwl/theme.sh

shopt -s nullglob globstar

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

password=$(printf '%s\n' "${password_files[@]}" | "bemenu" --prompt "Pass" -i -W 0.3 -c -l 20 --fn "${font} ${size}"  --ff $foreground  --nf $primary --tb $primary  --tf $on_primary --hf $foreground  --af $primary "$@")

[[ -n $password ]] || exit

pass show -c "$password" 2>/dev/null

