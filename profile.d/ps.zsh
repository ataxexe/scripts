#!/bin/zsh

# Configuration vars
DEVNULL_THEME_THRESHOLD=2
DEVNULL_THEME_PROMPT_CHAR="❯"
DEVNULL_THEME_PROMPT_ROOT_CHAR="#"
DEVNULL_THEME_PROMPT_ERROR_CHAR="✗"
DEVNULL_THEME_GIT_DIRTY_CHAR="*"
DEVNULL_THEME_GIT_SHA1_LENGTH=8

# Vars to use in prompt
local ps_char="$DEVNULL_THEME_PROMPT_CHAR"
local ps_char_error="$DEVNULL_THEME_PROMPT_ERROR_CHAR"
local ps_prefix=""
local ps_user="%{$fg[yellow]%}%n%{$reset_color%}"
local ps_hostname="%{$fg[magenta]%}%M%{$reset_color%}"
local ps_dir="%{$fg_bold[blue]%}%~%{$reset_color%}"
local r_prompt="%(?..%{$fg_bold[red]%}%?%{$reset_color%})"
local newline=$'\n'

# If user is root, change some vars in prompt
if [[ $UID == 0 ]]; then
  ps_char="%{$fg[red]%}${DEVNULL_THEME_PROMPT_ROOT_CHAR}%{$reset_color%}"
  ps_user="%{$fg[red]%}%n%{$reset_color%}"
fi

# Then, define the prompt based on the previous command exit code
local ps_prompt="%(?.%{$fg_bold[green]%}${ps_char}.%{$fg[red]%}${ps_char_error})%{$reset_color%}"

# If it's a ssh connection, displays user and host as the ps_prefix
if [[ -n "$SSH_CONNECTION" ]]; then
  ps_prefix="${ps_user}@${ps_hostname} "
fi

# Function to apply classifier suffixes to the current dir
ps_classifier() {
  # If it's a git project, outputs repo info
  git status >/dev/null 2>&1 && ps_git
}

# Grabs some git information to display at the prompt
ps_git() {
  local branch="$(git symbolic-ref --short HEAD)"
  local sha1=($(git log -1 --no-color --format=short 2>/dev/null))
  # Shows only the 
  sha1="${sha1[2]:0:${DEVNULL_THEME_GIT_SHA1_LENGTH}}"
  local color=""
  # Use a color convention for git branches
  case "${branch}" in
    master)           color="%{$fg_bold[red]%}"     ;;
    develop*)         color="%{$fg[green]%}"        ;;
    feature*)         color="%{$fg[yellow]%}"       ;;
    hotfix*)          color="%{$fg[magenta]%}"      ;;
    release*)         color="%{$fg[cyan]%}"         ;;
    *)                color="%{$fg[green]%}"        ;;
  esac
  # Checks if it's dirty
  if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
    branch="${branch}${DEVNULL_THEME_GIT_DIRTY_CHAR}"
  fi
  echo " ${color}${branch}%{$reset_color%} %{$fg[yellow]%}${sha1}%{$reset_color%}"
}

# Pre exec function to store the current elapsed time in shell
preexec() {
  typeset -ig ZSH_START=SECONDS
}

# Pre cmd function to calculate the last command elapsed time
precmd() {
  if [[ $ZSH_START -ge 0 ]]; then
    ZSH_ELAPSED=$(( SECONDS-ZSH_START ))
  else
    ZSH_ELAPSED=""
  fi
  ZSH_START=-1
}

# Checks if the last command lasted for more than the threshold
ps_elapsed_time() {
  if [[ $ZSH_ELAPSED -ge ${DEVNULL_THEME_THRESHOLD} ]]; then
    local elapsed=""
    local hours=$(( ZSH_ELAPSED / 60 / 60 ))
    local minutes=$(( ZSH_ELAPSED / 60 % 60 ))
    local seconds=$(( ZSH_ELAPSED % 60 ))
    (( hours > 0 )) && elapsed+="${hours}h "
    (( minutes > 0 )) && elapsed+="${minutes}m "
    elapsed+="${seconds}s"
    echo "%{$fg_bold[yellow]%}${elapsed}%{$reset_color%} "
  fi
}

PROMPT="${ps_prefix}${ps_dir}\$(ps_classifier)${newline}%{$reset_color%}${ps_prompt} "
RPROMPT="\$(ps_elapsed_time)$r_prompt"
