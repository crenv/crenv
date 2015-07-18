#!/usr/bin/env bats

load test_helper

create_hook() {
  mkdir -p "$1/$2"
  touch "$1/$2/$3"
}

@test "prints usage help given no argument" {
  run crenv-hooks
  assert_failure "Usage: crenv hooks <command>"
}

@test "prints list of hooks" {
  path1="${CRENV_TEST_DIR}/crenv.d"
  path2="${CRENV_TEST_DIR}/etc/crenv_hooks"
  create_hook "$path1" exec "hello.bash"
  create_hook "$path1" exec "ahoy.bash"
  create_hook "$path1" exec "invalid.sh"
  create_hook "$path1" which "boom.bash"
  create_hook "$path2" exec "bueno.bash"

  CRENV_HOOK_PATH="$path1:$path2" run crenv-hooks exec
  assert_success
  assert_output <<OUT
${CRENV_TEST_DIR}/crenv.d/exec/ahoy.bash
${CRENV_TEST_DIR}/crenv.d/exec/hello.bash
${CRENV_TEST_DIR}/etc/crenv_hooks/exec/bueno.bash
OUT
}

@test "supports hook paths with spaces" {
  path1="${CRENV_TEST_DIR}/my hooks/crenv.d"
  path2="${CRENV_TEST_DIR}/etc/crenv hooks"
  create_hook "$path1" exec "hello.bash"
  create_hook "$path2" exec "ahoy.bash"

  CRENV_HOOK_PATH="$path1:$path2" run crenv-hooks exec
  assert_success
  assert_output <<OUT
${CRENV_TEST_DIR}/my hooks/crenv.d/exec/hello.bash
${CRENV_TEST_DIR}/etc/crenv hooks/exec/ahoy.bash
OUT
}

@test "resolves relative paths" {
  path="${CRENV_TEST_DIR}/crenv.d"
  create_hook "$path" exec "hello.bash"
  mkdir -p "$HOME"

  CRENV_HOOK_PATH="${HOME}/../crenv.d" run crenv-hooks exec
  assert_success "${CRENV_TEST_DIR}/crenv.d/exec/hello.bash"
}

@test "resolves symlinks" {
  path="${CRENV_TEST_DIR}/crenv.d"
  mkdir -p "${path}/exec"
  mkdir -p "$HOME"
  touch "${HOME}/hola.bash"
  ln -s "../../home/hola.bash" "${path}/exec/hello.bash"

  CRENV_HOOK_PATH="$path" run crenv-hooks exec
  assert_success "${HOME}/hola.bash"
}
