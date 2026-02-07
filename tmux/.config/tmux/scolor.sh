#!/bin/bash
# Deterministic session-name -> color mapping
# Pinned sessions have fixed colors, others hash to a palette
session="$1"
case "$session" in
    gh) echo "colour3"; exit ;;
    ft) echo "white"; exit ;;
esac
palette=(colour2 colour3 colour4 colour5 colour6 colour13 colour14 colour130 colour166 colour172 colour208)
hash=$(printf '%s' "$session" | cksum | awk '{print $1}')
echo "${palette[$((hash % ${#palette[@]}))]}"
