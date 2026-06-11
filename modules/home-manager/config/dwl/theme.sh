# Fichier source pour définir le font, les couleurs et le fond d'écran
# de DWL

## Fonts ##
font="Adwaita Mono"
size=14

## Wallpaper ##
wallpaper=plage-costa-rica.jpg

## Couleur du wallpaper choisie avec hyprpicker ##
#hyprpickColor=D2A180
hyprpickColor=84A508

## Couleurs ##
black=000000
white=FFFFFF
bleuGbox=458588  #bleu gruvbox
vertGbox=98971a  #vert gruvbox

### variable pour dwlb
bg=$hyprpickColor  #vert gruvbox
inactiveFg=$bg #vert gruvbox

### variable pour bemenu-run
background="#${black}"
foreground="#${white}"
primary="#${bg}"
on_primary="#${black}"
fontsize="${font} ${size}"

export BEMENU_OPTS="-i -W 0.3 -c -l 20 \
  --fn $fontsize\
  --ff $foreground  \
  --nf $primary   \
  --tb $primary     \
  --tf $on_primary  \
  --hf $foreground     \
  --af $primary  "

### variables pour dwl 
focuscolor=$bg
