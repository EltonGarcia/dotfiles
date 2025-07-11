#!/bin/bash

#xdg-all-apps text/plain
#xdg-all-apps audio/mpeg
#xdg-all-apps image/svg+xml
#xdg-all-apps application/json
#xdg-all-apps x-scheme-handler/http

xdg-all-apps() {
    LOCAL="${XDG_DATA_HOME:-$HOME/.local/share}/applications/mimeinfo.cache"
    GLOBAL="/usr/share/applications/mimeinfo.cache"

    MATCHING="$(grep -h "$1" "$LOCAL" "$GLOBAL")"
    if [ -z "$MATCHING" ]; then
        echo "There are no application associated with $1"
        return
    fi
    echo "$MATCHING" |cut -d = -f 2 |\
        sed -z -e 's:\n::;s:;:\n:g' |\
        sort |uniq
}

xdg-all-apps "$1"

# Alternative
# grep -r 'x-scheme-handler/http' /usr/share/applications ~/.local/share/applications 2>/dev/null
