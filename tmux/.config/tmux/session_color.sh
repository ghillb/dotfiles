#!/bin/bash
# Deterministic session-name -> color mapping
# "gh" returns colour9 (original status bar color), others hash to a palette
session="$1"
if [ "$session" = "gh" ]; then
    echo "colour3"
    exit
fi
palette=(colour2 colour3 colour4 colour5 colour6 colour13 colour14 colour130 colour166 colour172 colour208)
hash=$(printf '%s' "$session" | cksum | awk '{print $1}')
echo "${palette[$((hash % ${#palette[@]}))]}"
