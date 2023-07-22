##### Keyboard #####
source $HOME/.zsh/zsh-keyboard.zsh

##### Substring History Search #####
source "$HOME/.zsh/zsh-history-substring-search.zsh"

##### Activate keybind #####
bindkey -v
bindkey "${key_info[Up]}" history-substring-search-up
bindkey "${key_info[Down]}" history-substring-search-down
bindkey "${key_info[Control]}P" history-substring-search-up
bindkey "${key_info[Control]}N" history-substring-search-down
bindkey "${key_info[Control]}R" history-incremental-search-backward

##### History options #####
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=214748364718
SAVEHIST=$HISTSIZE
setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_VERIFY
setopt APPENDHISTORY
setopt HIST_SAVE_NO_DUPS

##### Directory #####
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
setopt EXTENDED_GLOB
setopt MULTIOS
setopt NO_CLOBBER

##### Completion #####
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' rehash true
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:*:*:*:descriptions' format '%F{32}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' squeeze-slashes true
autoload -Uz compinit
compinit

##### Prompt #####
setopt correct
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats ' (%b)'
echo -ne '\e[1 q'
_git_color=32
_prompt_extra=''
_prompt_name=%n@%m
precmd_functions+=(vcs_info)

_cr=$'\n'
if [[ ! -z $VIM ]]; then
    _venv=""
    if [[ -d $VIRTUAL_ENV ]]; then 
        _venv="(venv) "
    fi
    _prompt_extra="${_cr}%F{red}$_venv(vim)%f"
fi

PROMPT=$'[$_prompt_name %(3~|..%2~|%~)]%F{$_git_color}$vcs_info_msg_0_%f$_prompt_extra %(!.#.$) '

# Reset PATH
[ -f ~/.zsh_paths ] && source ~/.zsh_paths

##### Tmux #####
if [[ -x $(command -v tmux) && -z $SSH_TTY && -z $TMUX && (${TERM_PROGRAM} =~ '^(Apple_Terminal|Guake|mintty)$' || ${TERM} == 'alacritty' || ! -z $WSL_DISTRO_NAME) ]]; then
    tmux -2 attach -t tmux_main || tmux -2 new -s tmux_main
fi
