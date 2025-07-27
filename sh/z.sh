#!/bin/bash
eval "$(lua ~/project/github/z.lua/z.lua  --init bash once enhanced fzf)"

export _ZL_DATA=~/.cache/zlua

alias zc='z -c'
alias zz='z -i'
alias zf='z -f'
alias zb='z -b'
