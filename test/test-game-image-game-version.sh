#!/bin/sh
set -eu

SCRIPT_DIR=$( cd  $( dirname "$0" ) && pwd )
cd "$SCRIPT_DIR"

for i in $( ls hlds-* srcds-* | grep -v srcds-cs2 ); do
    echo "[$i]"
    cat "$i" | grep -iE '\bexe\b|version'
    echo
    cat "$i" | grep -iE '\bexe\b|version' | sed 's/[^0-9]//g'
    echo
done

for i in srcds-cs2-query; do
    echo "[$i]"
    cat "$i" | tr "[:cntrl:]" "\\n" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'
    echo
    cat "$i" | tr "[:cntrl:]" "\\n" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sed 's/[^0-9]//g'
    echo
done
