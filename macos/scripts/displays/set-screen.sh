#!/bin/bash

# Script Info:
## Get current config:
## > displayplacer list
## Set default config:
## > displayplacer "id:441B2C7A-1C48-F9CD-D6FE-B0C20DE14753 res:1920x1080 hz:60 color_depth:8 enabled:true scaling:off origin:(0,0) degree:0" "id:EE0A6F5C-ACBC-D8F2-3BAD-3DC589F2762E res:1440x900 color_depth:8 enabled:true scaling:on origin:(1920,0) degree:0"
## Set mirror config:
## >displayplacer "id:EE0A6F5C-ACBC-D8F2-3BAD-3DC589F2762E+441B2C7A-1C48-F9CD-D6FE-B0C20DE14753 res:1440x900 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0"

displayplacer --version > /dev/null
if [[ "$?" != "0" ]]; then
     echo -e "displayplacer is not installed\n"
     echo -e "Check: https://github.com/jakehilborn/displayplacer"
fi

# Hardcoded display ID

mainDiplayID="441B2C7A-1C48-F9CD-D6FE-B0C20DE14753"
macDisplayID="EE0A6F5C-ACBC-D8F2-3BAD-3DC589F2762E"

# Hardcoded resolutions
defaultRes="1920x1080"
lowRes="1280x720"
macRes="1440x900"

set_low_resolution() {
    change_resolution $mainDiplayID $lowRes
    osascript -e "display notification \"Screen $displayId resolution set to $targetResolution\""
}

change_resolution() {
    local displayID=$1
    local targetResolution=$2
    local scaling="off"

    displayplacer "id:$mainDiplayID res:$targetResolution hz:60 color_depth:8 enabled:true scaling:$scaling origin:(0,0) degree:0" "id:$macDisplayID res:$macRes color_depth:8 enabled:true scaling:on origin:(1920,0) degree:0"
}

set_mirror() {
    targetResolution=$macRes
    scaling="off"
    displayplacer "id:$mainDiplayID+$macDisplayID res:$targetResolution color_depth:8 enabled:true scaling:$scaling origin:(0,0) degree:0"
    change_resolution $mainDiplayID $lowRes
    osascript -e "display notification \"Mirror screen configuration enabled\""
}

set_default() {
    scaling="off"
    displayplacer "id:$mainDiplayID res:$defaultRes hz:60 color_depth:8 enabled:true scaling:$scaling origin:(0,0) degree:0" "id:$macDisplayID res:$macRes color_depth:8 enabled:true scaling:on origin:(1920,0) degree:0"
    osascript -e "display notification \"Default screen configuration enabled\""
}

get_value_from_info(){
    echo "$1" | awk -F ': ' '{print $2}'
}

get_diplays(){
     local PersistentScreenId="Persistent screen id:"
     # Get persistent screen id and the 4 lines below it.
     local info=$(displayplacer list | grep "$PersistentScreenId" -A 4)

     local displaysIds=()
     local diplayNames=()

     local idsContent=$(echo "$info" | grep "$PersistentScreenId")
     while IFS= read -r id_line; do
         value=$(get_value_from_info "$id_line")
         displaysIds+=("$value")
     done <<< "$idsContent"

     local typesContent=$(echo "$info" | grep "Type:")
     while IFS= read -r type_line; do
         value=$(get_value_from_info "$type_line")
         diplayNames+=("$value")
     done <<< "$typesContent"

     for index in "${!displaysIds[@]}"; do
         id="${displaysIds[index]}"
         name="${diplayNames[index]}"
         echo $(printf "%s - %s" "$name" "$id")
     done
}

# Check parameter and set resolution accordingly
case "$1" in
    --default)
        set_default
        ;;
    --low)
        change_resolution $mainDiplayID $lowRes
        ;;
    --mirror)
        set_mirror
        ;;
    --info)
        get_diplays
        ;;
    *)
        echo "Usage: $0 --default | -- mirror | --low"
        exit 1
        ;;
esac

