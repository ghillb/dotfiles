# dotfiles
My take on Bash, tmux and Vim customization.

## deployment:

1. clone repo to `~/`
2. execute the deploy script: `./deploy`
3. relog
  
## automatic update and initialization

* run `initbash` function
  
## config overview
### [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell))
* `cd $1` has been aliased to `cd $1 && ls`
* `iploc` outputs your public ip and ip location
* `tx` executes `tmux attach` or `tmux new` (when there is no attachable session)
* `initbash` updates the dotfiles and invokes tmux
* sets `DISPLAY` variable for VcXsrv

| key binding | effect        |
| :-----------|:--------------|
| Ctrl-H      | runs `cd ~/`  |
| Ctrl-B      | runs `cd ..`  |
| Ctrl-T      | runs `tx`     |
| Ctrl-E      | runs `ranger` |
| F10         | runs `htop`   |
| Ctrl-G      | puts `git add . && git commit -m "" && git push` into buffer |

### [tmux](https://en.wikipedia.org/wiki/Tmux)
* added prefix indicator to statusbar
* rebind of prefix to `Ctrl-Space`
* changed window and pane base index to 1

| key binding (prefixed) | effect                  |
| :----------------------|:------------------------|
| r                      | reload `tmux.conf`      |
| \                      | split pane vertically   |
| -                      | split pane horizontally |

| key binding         | effect                       |
| :-------------------|:-----------------------------|
| Alt-Left/Right      | previous/next windows        |
| Alt-Shift-Left/Right| swap window one left/right   |
| Alt-hjkl            | select panes (vim direction) |
| Alt-Shift-hjkl      | resize panes (vim direction) |

### [Vim](https://en.wikipedia.org/wiki/Vim_(text_editor))
* set nocompatible mode
* turn off audible bell
* enable desert color scheme
* enable syntax highlighting
* change encoding/decoding to utf8
* display relative line numbers
* enable `:q` confirmation dialogue
* highlight matching braces
* disable swap and backup files
* backspace over eol
* autoindent
* expand tabs into 4 space
* highlight search results
* case insensitive search
* provide Osc52yank support
