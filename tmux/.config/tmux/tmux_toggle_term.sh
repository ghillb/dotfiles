#!/bin/bash
FLOAT_TERM_SESSION="floating_term"

if [ "$(tmux display-message -p -F '#{session_name}')" = "$FLOAT_TERM_SESSION" ]; then
    tmux detach-client
else
    tmux popup -d '#{pane_current_path}' -w 80% -h 80% -E "tmux attach-session -t $FLOAT_TERM_SESSION || tmux new-session -s $FLOAT_TERM_SESSION"
fi
