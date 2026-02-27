# bash completion for cardpointers

_cardpointers() {
  local cur prev words cword

  if declare -F _init_completion >/dev/null 2>&1; then
    _init_completion -n = || return
  else
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    words=("${COMP_WORDS[@]}")
    cword=$COMP_CWORD
  fi

  local subcommands="login logout status recommend cards offers search profiles ping tools help completions"

  if [[ $cword -eq 1 ]]; then
    COMPREPLY=( $(compgen -W "$subcommands --version" -- "$cur") )
    return
  fi

  local cmd="${words[1]}"
  case "$cmd" in
    recommend)
      case "$prev" in
        --merchant|-m|--profile|-p|--amount|-a)
          return
          ;;
      esac
      COMPREPLY=( $(compgen -W "--merchant -m --profile -p --amount -a --json -j" -- "$cur") )
      ;;
    cards)
      case "$prev" in
        --status|-s)
          COMPREPLY=( $(compgen -W "approved active all applied denied closed" -- "$cur") )
          return
          ;;
        --bank|-b|--profile|-p|--limit|-l)
          return
          ;;
      esac
      COMPREPLY=( $(compgen -W "--status -s --bank -b --profile -p --limit -l --json -j" -- "$cur") )
      ;;
    offers)
      case "$prev" in
        --expiring|-e)
          COMPREPLY=( $(compgen -W "7 14 30" -- "$cur") )
          return
          ;;
        --sort|-r)
          COMPREPLY=( $(compgen -W "expiring value card" -- "$cur") )
          return
          ;;
        --limit|-l|--profile|-p|--bank|-b|--card|-c|--category|-y|--type|-t)
          return
          ;;
      esac
      COMPREPLY=( $(compgen -W "--expiring -e --favorite -f --sort -r --limit -l --profile -p --json -j --status -s --card -c --category -y --type -t --bank -b" -- "$cur") )
      ;;
    search)
      case "$prev" in
        --limit|-l|--profile|-p)
          return
          ;;
      esac
      COMPREPLY=( $(compgen -W "--favorite -f --limit -l --profile -p --json -j" -- "$cur") )
      ;;
    profiles)
      COMPREPLY=( $(compgen -W "--json -j" -- "$cur") )
      ;;
    completions)
      COMPREPLY=( $(compgen -W "bash zsh" -- "$cur") )
      ;;
    help)
      COMPREPLY=( $(compgen -W "$subcommands" -- "$cur") )
      ;;
  esac
}

complete -F _cardpointers cardpointers
