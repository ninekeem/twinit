#!/bin/sh

env_to_commands() {
    OPT="$(echo "${1}" | tr '[:upper:]' '[:lower:]' | awk -F'=' '{ print $1 }')"
    VALUE="$(echo "${1}" | awk -F'=' '{ print $2 }')"
    configurator.sh "$OPT" "$VALUE"
}

permissions() {
    env | grep -e "^MOD_COMMAND" -e "^ACCESS_LEVEL" | while IFS= read -r i
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

parse_envs() {
    env | grep "$1" | while IFS= read -r i
    do
        if [ "$2" = "true" ]
        then
            i="$(echo "$i" | cut -d'_' -f2-)"
        fi
        env_to_commands "$i"
    done
}

parse_envs ^EC_ false
parse_envs ^SV_ false
parse_envs ^TW_ true
permissions

if [ "$VOTE_GENERATOR" = "true" ]
then
    echo "[init] VOTE_GENERATOR = $VOTE_GENERATOR, executing votegenerator.sh..."
    votegenerator.sh
else
    echo "[init] VOTE_GENERATOR = $VOTE_GENERATOR, vote generator will not be executed"
fi
