#!/bin/sh

add_vote() {
    configurator.sh "add_vote \"$1"\" "\"$2"\"
}

header() {
    add_vote "---$1---" "${VG_DELIMITER:-"say Do not touch me!"}"
}

custom() {
    header "$1"
    env | sort | grep "$2" | while IFS= read -r i
    do
        VALUE="$(echo "${i}" | awk -F'=' '{ print $2 }')"
        OPT="$(echo "${i}" | awk -F'=' '{ print $3 }')"
        add_vote "$VALUE" "$OPT"
    done
}

if env | grep -q "^VG_AD" && [ "$GENERATE_VG_ADS" -eq 1 ]
then
    custom "ADS" "^VG_AD"
fi

if env | grep -q "^VG_MISC" && [ "$GENERATE_VG_MISC" -eq 1 ]
then
    custom "MISC" "^VG_MISC"
fi

scorelimits_custom() {
    for i in $1
    do
        add_vote "$i" "sv_scorelimit $i"
    done
}

if [ -n "$VG_SCORELIMITS" ] && [ "$GENERATE_VG_SCORELIMITS" -eq 1 ]
then
    header SCORELIMIT
    scorelimits_custom "$VG_SCORELIMITS"
fi

vg_spectator_slots() {
    if [ -z "$VS_SPECTATOR_SLOTS" ]
    then
        i=14
        while [ "$i" -ge 0 ]
        do
            VG_SPECTATOR_SLOTS="$VG_SPECTATOR_SLOTS""$i "
            i=$((i-2))
        done
    fi
    for i in $VG_SPECTATOR_SLOTS
    do
        j=$(((16 - i) / 2))
        add_vote "$j vs $j" "sv_spectator_slots $i"
    done
}

if [ "$GENERATE_VG_SPECTATOR_SLOTS" -eq 1 ]
then
    header SLOTS
    vg_spectator_slots
fi

maps() {
    find "$MAPS_DIR" -iname '*.map' | while read -r i
    do
        i="$(echo "$i" | sed -e 's&'"$MAPS_DIR"/'&&' | sed -e s/\.map//)"
        add_vote "$i" "sv_map $i"
    done
}

if find "$MAPS_DIR" -mindepth 1 -maxdepth 1 | read -r && [ "$GENERATE_VG_MAPS" -eq 1 ]
then
    header MAPS
    maps
fi
