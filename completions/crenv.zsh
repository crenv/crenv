if [[ ! -o interactive ]]; then
    return
fi

compctl -K _crenv crenv

_crenv() {
  local words completions
  read -cA words

  if [ "${#words}" -eq 2 ]; then
    completions="$(crenv commands)"
  else
    completions="$(crenv completions ${words[2,-2]})"
  fi

  reply=("${(ps:\n:)completions}")
}
