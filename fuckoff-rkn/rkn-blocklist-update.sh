#!/bin/sh
ZHOSTLIST='/var/lib/fuckoff-rkn/hosts.txt'
ZHOSTUSERLIST='/etc/fuckoff-rkn/hosts.txt'

TMPDIR="$(mktemp -t "fuckoff-rkn.XXXXXXXXXXXXXX" -d)"
ZREESTR="$TMPDIR/hosts.txt"
ZURL="https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv"

curl -k --fail --max-time 600 --connect-timeout 5 --retry 3 --max-filesize 251658240 "$ZURL" > "$ZREESTR" ||
{
 echo "reestr list download failed"
 exit 2
}

dlsize=$(LANG=C wc -c "$ZREESTR" | xargs | cut -f 1 -d ' ')
if test "$dlsize" -lt 204800; then
 echo "list file is too small. can be bad."
 exit 2
fi

cp "$ZHOSTUSERLIST" "$ZHOSTLIST"
echo >> "$ZHOSTLIST" # Add new line
(LANG=C cut -s -f2 -d';' "$ZREESTR" | LANG=C sed -Ee 's/^\*\.(.+)$/\1/' -ne 's/^[a-z0-9A-Z._-]+$/&/p' | awk '{ print tolower($0) }' ) | sort -u >> "$ZHOSTLIST"
rm -rf "$TMPDIR"
