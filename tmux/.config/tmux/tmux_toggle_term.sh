#!/bin/bash
FLOAT_TERM_SESSION="ft"
STATE_FILE="/tmp/tmux_float_maximized"

if [ "$(tmux display-message -p -F '#{session_name}')" = "$FLOAT_TERM_SESSION" ]; then
    tmux detach-client
else
    if [ "$1" = "toggle-size" ]; then
        if [ -f "$STATE_FILE" ]; then
            rm "$STATE_FILE"
            SIZE_W="80%"; SIZE_H="80%"; BORDER=""
        else
            touch "$STATE_FILE"
            SIZE_W="100%"; SIZE_H="100%"; BORDER="-B"
        fi
    elif [ -f "$STATE_FILE" ]; then
        SIZE_W="100%"; SIZE_H="100%"; BORDER="-B"
    else
        SIZE_W="80%"; SIZE_H="80%"; BORDER=""
    fi
    tmux popup -d '#{pane_current_path}' -w "$SIZE_W" -h "$SIZE_H" $BORDER -E "tmux attach-session -t $FLOAT_TERM_SESSION || tmux new-session -s $FLOAT_TERM_SESSION"
fi
