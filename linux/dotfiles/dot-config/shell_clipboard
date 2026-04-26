clipboard-ctl() {
  local mode="auto"
  local output=0
  local no_newline=0

  # --- Parse flags ---
  while [[ "$1" == -* ]]; do
    case "$1" in
      -c|--copy)   mode="copy" ;;
      -p|--paste)  mode="paste" ;;
      -o|--output) output=1 ;;
      -n)          no_newline=1 ;;
      -h|--help)
        cat <<'EOF'
pp - clipboard helper

Options:
  -c, --copy     Force copy
  -p, --paste    Force paste
  -o, --output   Copy AND output (tee-like)
  -n             Do NOT append newline (native wl-copy/wl-paste behavior)
EOF
        return 0
        ;;
      *)
        echo "pp: unknown option: $1" >&2
        return 1
        ;;
    esac
    shift
  done

  # --- Backend detection ---
  local copy_cmd paste_cmd

  if command -v wl-copy >/dev/null 2>&1; then
    copy_cmd="wl-copy"
    paste_cmd="wl-paste"
  elif command -v xclip >/dev/null 2>&1; then
    copy_cmd="xclip -selection clipboard"
    paste_cmd="xclip -selection clipboard -o"
  else
    echo "pp: no clipboard tool found" >&2
    return 1
  fi

  # --- Apply -n if supported (Wayland only) ---
  if [[ $no_newline -eq 1 && "$copy_cmd" == "wl-copy" ]]; then
    copy_cmd+=" -n"
  fi

  if [[ $no_newline -eq 1 && "$paste_cmd" == "wl-paste" ]]; then
    paste_cmd+=" -n"
  fi

  # --- Auto mode ---
  if [[ "$mode" == "auto" ]]; then
    if [ -t 0 ]; then
      mode="paste"
    else
      mode="copy"
    fi
  fi

  # --- Execute ---
  case "$mode" in
    copy)
      if [[ $output -eq 1 ]]; then
        tee >($copy_cmd)
      else
        eval "$copy_cmd"
      fi
      ;;
    paste)
      eval "$paste_cmd"
      ;;
  esac
}

# copy and paste
alias pp='clipboard-ctl -n' # use -n to remove newline
alias ppp='clipboard-ctl -p -n' # use -n to remove newline
alias ppc='clipboard-ctl -c -n' # use -n to remove newline
alias pps='_dquote' # paste clipboard content with double quotes
alias tpp='tee >(ppc)' # print and copy
alias pplc='fc -ln -1 | tpp' # copy the last executed command to clipboard
alias pcc='pplc'
alias pwdcc='pwd | tpp'
#alias ppe='ppp | tee >(vipe | tpp)' # edit clipboard content
alias ppe='ppp | vipe | tpp' # edit clipboard content

# use clipboard content as parameter to the given command:
# usage:
#   ppx echo
#   ppx echo {}
#   ppx mkdir
#   ppx rm -rf {}
ppx() {
  local clip=$(ppp)
  local args=()
  local used_placeholder=false

  for arg in "$@"; do
    if [[ "$arg" == "{}" ]]; then
      args+=("$clip")
      used_placeholder=true
    else
      args+=("$arg")
    fi
  done

  # If no {} was found, append clipboard at the end
  if [[ $used_placeholder == false ]]; then
    args+=("$clip")
  fi

  "${args[@]}"
}

# double quote clipboard content
_dquote() {
  content=$(ppp)
  printf '"%s"' "$content"
}
