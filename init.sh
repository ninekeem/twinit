#!/bin/sh

env_to_commands() {
    OPT="$(echo "${1}" | tr '[:upper:]' '[:lower:]' | awk -F'=' '{ print $1 }')"
    VALUE="$(echo "${1}" | awk -F'=' '{ print $2 }')"
    configurator.sh "$OPT" "$VALUE"
}

parse_envs() {
    env | sort | grep "$1" | while IFS= read -r i
    do
        if [ "$2" -eq 1 ]
        then
            i="$(echo "$i" | cut -d'_' -f2-)"
        fi
        env_to_commands "$i"
    done
}

permissions() {
    env | sort | grep -e "^MOD_COMMAND" -e "^ACCESS_LEVEL" | while IFS= read -r i
    do
        TYPE="$(echo "${i}" | awk -F'=' '{ print $1 }')"
        VALUE="$(echo "${i}" | awk -F'=' '{ print $2 }')"
        OPT="$(echo "${i}" | awk -F'=' '{ print $3 }')"
        if echo "$TYPE" | grep -q "^ACCESS_LEVEL"
        then
            configurator.sh "access_level $VALUE" "$OPT"
        else
            configurator.sh "mod_command $VALUE" "$OPT"
        fi
    done
}

execs() {
    env | sort | grep "^EXEC" | while IFS= read -r i
    do
        VALUE="$(echo "${i}" | awk -F'=' '{ print $2 }')"
        configurator.sh "exec" "$VALUE"
    done
}

if [ "$REFILL_CONFIG" -eq 1 ]
then
    true > "$CONFIG_PATH"
fi

parse_envs ^EC_ 0
parse_envs ^SV_ 0
parse_envs ^TW_ 1
permissions
execs

if [ "$GENERATE_VG" -eq 1 ]
then
    echo "[init] GENERATE_VG = $GENERATE_VG, executing votegenerator.sh..."
    votegenerator.sh
else
    echo "[init] GENERATE_VG = $GENERATE_VG, vote generator will not be executed"
fi
