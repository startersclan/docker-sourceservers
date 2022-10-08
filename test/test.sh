#!/bin/sh
set -eu

for i in $( ls hlds_* ); do echo "[$i]"; cat "$i" | grep -iE '\bexe\b|version' | sed 's/[^0-9]//g'; echo; done
for i in $( ls srcds_* ); do echo "[$i]"; cat "$i" | grep -iE '\bexe\b|version' | sed 's/[^0-9]//g'; echo; done
