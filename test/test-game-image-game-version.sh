#!/bin/sh
set -eu

SCRIPT_DIR=$( cd  $( dirname "$0" ) && pwd )
cd "$SCRIPT_DIR"

for i in $( ls hlds-* ); do echo "[$i]"; cat "$i" | grep -iE '\bexe\b|version' | sed 's/[^0-9]//g'; echo; done
for i in $( ls srcds-* ); do echo "[$i]"; cat "$i" | grep -iE '\bexe\b|version' | sed 's/[^0-9]//g'; echo; done
