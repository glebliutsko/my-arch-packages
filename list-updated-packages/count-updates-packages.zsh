#!/usr/bin/zsh

LIST_UPDATED_FILE='/run/listupdates'

print_count_update() {
    if [[ ! -f $LIST_UPDATED_FILE ]] || [[ $(cat $LIST_UPDATED_FILE) == "Error" ]]; then
        echo N
    else
        cat $LIST_UPDATED_FILE | wc -l 
    fi
}

follow() {
    while inotifywait -q -e close_write,delete --include ${LIST_UPDATED_FILE:t} ${LIST_UPDATED_FILE:h} > /dev/null; do
        print_count_update
    done
}

zparseopts -D -E -F -- \
    -follow=is_follow \
    || exit 1

print_count_update
[[ -n $is_follow ]] && follow
