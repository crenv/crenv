unset CRENV_VERSION
unset CRENV_DIR

if enable -f "${BATS_TEST_DIRNAME}"/../libexec/crenv-realpath.dylib realpath 2>/dev/null; then
  CRENV_TEST_DIR="$(realpath "$BATS_TMPDIR")/crenv"
else
  if [ -n "$CRENV_NATIVE_EXT" ]; then
    echo "crenv: failed to load \`realpath' builtin" >&2
    exit 1
  fi
  CRENV_TEST_DIR="${BATS_TMPDIR}/crenv"
fi

# guard against executing this block twice due to bats internals
if [ "$CRENV_ROOT" != "${CRENV_TEST_DIR}/root" ]; then
  export CRENV_ROOT="${CRENV_TEST_DIR}/root"
  export HOME="${CRENV_TEST_DIR}/home"
  export CRENV_HOOK_PATH="${CRENV_ROOT}/crenv.d"

  PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
  PATH="${CRENV_TEST_DIR}/bin:$PATH"
  PATH="${BATS_TEST_DIRNAME}/../libexec:$PATH"
  PATH="${BATS_TEST_DIRNAME}/libexec:$PATH"
  PATH="${CRENV_ROOT}/shims:$PATH"
  export PATH
fi

teardown() {
  rm -rf "$CRENV_TEST_DIR"
}

flunk() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo "$@"
    fi
  } | sed "s:${CRENV_TEST_DIR}:TEST_DIR:g" >&2
  return 1
}

assert_success() {
  if [ "$status" -ne 0 ]; then
    flunk "command failed with exit status $status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_failure() {
  if [ "$status" -eq 0 ]; then
    flunk "expected failed exit status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_equal() {
  if [ "$1" != "$2" ]; then
    { echo "expected: $1"
      echo "actual:   $2"
    } | flunk
  fi
}

assert_output() {
  local expected
  if [ $# -eq 0 ]; then expected="$(cat -)"
  else expected="$1"
  fi
  assert_equal "$expected" "$output"
}

assert_line() {
  if [ "$1" -ge 0 ] 2>/dev/null; then
    assert_equal "$2" "${lines[$1]}"
  else
    local line
    for line in "${lines[@]}"; do
      if [ "$line" = "$1" ]; then return 0; fi
    done
    flunk "expected line \`$1'"
  fi
}

refute_line() {
  if [ "$1" -ge 0 ] 2>/dev/null; then
    local num_lines="${#lines[@]}"
    if [ "$1" -lt "$num_lines" ]; then
      flunk "output has $num_lines lines"
    fi
  else
    local line
    for line in "${lines[@]}"; do
      if [ "$line" = "$1" ]; then
        flunk "expected to not find line \`$line'"
      fi
    done
  fi
}

assert() {
  if ! "$@"; then
    flunk "failed: $@"
  fi
}

# Output a modified PATH that ensures that the given executable is not present,
# but in which system utils necessary for crenv operation are still available.
path_without() {
  local exe="$1"
  local path="${PATH}:"
  local found alt util
  for found in $(which -a "$exe"); do
    found="${found%/*}"
    if [ "$found" != "${CRENV_ROOT}/shims" ]; then
      alt="${CRENV_TEST_DIR}/$(echo "${found#/}" | tr '/' '-')"
      mkdir -p "$alt"
      for util in bash head cut readlink greadlink; do
        if [ -x "${found}/$util" ]; then
          ln -s "${found}/$util" "${alt}/$util"
        fi
      done
      path="${path/${found}:/${alt}:}"
    fi
  done
  echo "${path%:}"
}

create_hook() {
  mkdir -p "${CRENV_HOOK_PATH}/$1"
  touch "${CRENV_HOOK_PATH}/$1/$2"
  if [ ! -t 0 ]; then
    cat > "${CRENV_HOOK_PATH}/$1/$2"
  fi
}

# vim: se et ts=2 sw=2 sts=2 ft=sh :
