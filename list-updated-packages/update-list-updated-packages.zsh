#!/bin/zsh

if [[ $UID != 0 ]]; then
    >&2 echo "Run not as root"
    exit 1
fi

LIST_UPDATES_FILE='/run/listupdates'

updates=$(checkupdates 2> /dev/null)
case $? in
    0)
        echo $updates > $LIST_UPDATES_FILE
        ;;
    1)
        if [[ ! -f $LIST_UPDATES_FILE ]]; then
            echo -n Error > $LIST_UPDATES_FILE
        fi

        >&2 echo "Cannot fetch updates"
        ;;
    2)
        > $LIST_UPDATES_FILE
        ;;
esac
