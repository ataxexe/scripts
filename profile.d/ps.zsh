#!/bin/zsh

local ps_dir="%{$fg_bold[blue]%}%~%{$reset_color%}"
local ps_prompt="%(?.%{$fg_bold[green]%}❯.%{$fg[red]%}✗)%{$reset_color%}"
local r_prompt="%(?..%{$fg_bold[red]%}%?%{$reset_color%})"
local newline=$'\n'

preexec() {
  typeset -ig ZSH_START=SECONDS
}
precmd() {
  if [[ $ZSH_START -ge 0 ]]; then
    ZSH_ELAPSED=$(( SECONDS-ZSH_START ))
  else
    ZSH_ELAPSED=""
  fi
  ZSH_START=-1
}

ps_classifier() {
  git status >/dev/null 2>&1 && ps_git
}

ps_git() {
  local branch="$(git symbolic-ref --short HEAD)"
  local sha1=($(git log -1 --no-color --format=short 2>/dev/null))
  sha1="${sha1[2]:0:7}"
  local color=""
  case "${branch}" in
    master)           color="%{$fg[red]%}"     ;;
    development*)     color="%{$fg[green]%}"   ;;
    feature*)         color="%{$fg[yellow]%}"  ;;
    hotfix*)          color="%{$fg[magenta]%}" ;;
    release*)         color="%{$fg[cyan]%}"    ;;
    *)                color="%{$fg[green]%}"   ;;
  esac
  echo " ${color}${branch}%{$reset_color%} %{$fg[yellow]%}${sha1}%{$reset_color%}"
}

ps_elapsed_time() {
  local total_seconds=${ZSH_ELAPSED}
  if [[ $total_seconds -gt 1 ]]; then
    local human=""
    local days=$(( total_seconds / 60 / 60 / 24 ))
    local hours=$(( total_seconds / 60 / 60 % 24 ))
    local minutes=$(( total_seconds / 60 % 60 ))
    local seconds=$(( total_seconds % 60 ))
    (( days > 0 )) && human+="${days}d "
    (( hours > 0 )) && human+="${hours}h "
    (( minutes > 0 )) && human+="${minutes}m "
    human+="${seconds}s"
    echo "%{$fg_bold[yellow]%}${human}%{$reset_color%} "
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="⑂ %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN="✓"

PROMPT="${ps_dir}\$(ps_classifier)${newline}%{$reset_color%}${ps_prompt}"
RPROMPT="\$(ps_elapsed_time)$r_prompt"
