#!/usr/bin/env bash

ps1_set() {
  local user_color=32
  local host_color=33
  local prompt_char='$'
  local separator="\n"
  local enclose=()


  case $(whoami) in
    apache|git|jboss|postgre)
      user_color=33
  esac

  # Auxiliary function to print colorized texts
  ps_color() {
    printf "\033[${3}${2}m$1\033[0m"
  }

  ps1_id() {
    if [[ $UID -eq 0 ]]; then
      ps_color '\\u' 31
    else
      ps_color '\\u' $user_color
    fi
    printf "@"
    ps_color '\h ' $host_color
  }

  ps1_dir() {
    ps_color '\w' "1;34"
  }

  ps1_extensions() {
    ps1_git
  }

  ps1_git() {
    local branch="" line="" attr="" color="" mod=""

    local sha1=($(git log -1 --no-color --format=short 2>/dev/null))
    sha1=${sha1[1]:0:7}

    shopt -s extglob

    while read -r line; do
      case "${line}" in
        [[=*=]][[:space:]]*)
          branch="${line/[[=*=]][[:space:]]/}"
          ;;
      esac
    done < <(git branch 2>/dev/null)

    case $branch in
      prod*|stable)     color=41 ; attr="1;37m\033[" ;;
      master)           color=31                     ;;
      stage)            color=33                     ;;
      gh-pages)         color=35                     ;;
      work|dev*)        color=36                     ;;
      *)
        if [[ -n "${branch}" ]]; then
          color=32
        else
          color=0
        fi
        ;;
    esac

    if [[ -n "${branch}" ]]; then
      local status="$(git status -sb 2>/dev/null)"
      if [[ "${status}" == "##"*"[ahead"* ]]; then
        mod="*"
      fi
    fi

    if [[ color -gt 0 ]]; then
      printf ' ('
      ps_color "${branch}:${sha1}${mod}" ${color} ${attr}
      printf ')'
    fi
  }

  if [[ $UID -eq 0 ]]; then
    prompt_char='#'
  fi

  while [[ $# -gt 0 ]]; do
    token="$1" ; shift

    case $token in
      --trace)
        ps_trace
        ;;
      --prompt)
        prompt_char="$1" ; shift
        ;;
      --separator)
        separator="$1" ; shift
        ;;
      --enclose)
        enclose=($1 $2) ; shift ; shift
        ;;
      --user-color)
        user_color=$1 ; shift
        ;;
      --host-color)
        host_color=$1 ; shift
        ;;
      --no-extensions)
        ps1_extensions() { :; }
        ;;
      *)
        true
        ;;
    esac
  done

  PS1="${enclose[0]}$(ps1_id)$(ps1_dir)\$(ps1_extensions)${enclose[1]}${separator}${prompt_char} "
}

ps_trace() {
  export PS4='+[${BASH_SOURCE}] : ${LINENO} : ${FUNCNAME[0]}:+${FUNCNAME[0]}() $ }'
  set -o xtrace
}

ps1_set "$PS_OPTIONS"