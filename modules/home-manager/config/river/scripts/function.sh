#/bin/sh

for i in $(seq 1 9)
do
    tags=$((1 << ($i - 1)))

    # Alt+[1-9] to focus tag [0-8]
    riverctl map normal Alt $i set-focused-tags $tags
    riverctl map normal Alt F$i set-focused-tags $tags
    riverctl map normal Mod5 F$i set-focused-tags $tags

    # Alt+Shift+[1-9] to tag focused view with tag [0-8]
    riverctl map normal Alt+Shift $i set-view-tags $tags
    riverctl map normal Alt+Shift F$i set-view-tags $tags
    riverctl map normal Mod5+Shift F$i set-view-tags $tags

    # Alt+Control+[1-9] to toggle focus of tag [0-8]
    riverctl map normal Alt+Control $i toggle-focused-tags $tags
    riverctl map normal Alt+Control F$i toggle-focused-tags $tags
    riverctl map normal Mod5+Control F$i toggle-focused-tags $tags

    # Alt+Shift+Control+[1-9] to toggle tag [0-8] of focused view
    riverctl map normal Alt+Shift+Control $i toggle-view-tags $tags
    riverctl map normal Alt+Shift+Control F$i toggle-view-tags $tags
    riverctl map normal Mod5+Shift+Control F$i toggle-view-tags $tags
done

