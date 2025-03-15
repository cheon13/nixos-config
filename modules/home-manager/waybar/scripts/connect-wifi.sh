#/bin/sh

# Script pour un menu pour se connecter à un réseau wifi

export BEMENU_OPTS="-i -W 0.3 -c -l 20 --fn JetBrainsMono 14 --fb '#282828' --ff '#ebdbb2' --nb '#282828' --nf '#ebdbb2' --tb '#282828' --hb '#282828' --tf '#fb4934' --hf '#fabd2f'  --af '#ebdbb2' --ab '#282828' -B 2 --bdr '#ebdbb2'"

ssid=$(nmcli -f SSID device wifi | bemenu --prompt "Choisir le réseau" |sed 's/[[:blank:]]*$//' )
#echo "->$ssid<-"
networkpassword=$(echo "entrez un mot de passe" | bemenu --password indicator)
#echo "->$networkpassword<-"
nmcli dev wifi connect "$ssid" password "$networkpassword"
