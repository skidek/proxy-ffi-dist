#!/bin/bash

readarray -t SUBMODULES <<< `git config --file .gitmodules --get-regexp path | awk '{ print $2 }'`
readarray -t SUBMODULE_URLS <<< `git config --file .gitmodules --get-regexp url | awk '{ print $2 }'`

SINCE=`git log -1 --format=%aI`
SINCE_TITLE=`git log -1 --format=%ai`

count=${#SUBMODULES[@]}

echo "## changelog $SINCE_TITLE ota"

for (( i=0; i<${count}; i++ ));
do
    m=${SUBMODULES[$i]}
    u=${SUBMODULE_URLS[$i]}

    cd "./$m"
    readarray -t log <<< `git log --date iso --since "$SINCE" --until HEAD --no-merges --pretty="format:[(%h)]($u/commit/%H) %an: %s"`

    echo ""
    echo "### $m"
    if [ ! -z "$log" ] 
    then
        log[0]="**${log[0]}**"
        
        for e in "${log[@]}"
        do
            echo "- $e"
        done
    else
        echo '`nincs valtozas`'
    fi

    cd ..
done