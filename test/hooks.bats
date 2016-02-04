#!/usr/bin/env bats

load test_helper

@test "prints usage help given no argument" {
  run crenv-hooks
  assert_failure "Usage: crenv hooks <command>"
}

@test "prints list of hooks" {
  path1="${CRENV_TEST_DIR}/crenv.d"
  CRENV_HOOK_PATH="$path1"
  create_hook exec "hello.bash"
  create_hook exec "ahoy.bash"
  create_hook exec "invalid.sh"
  create_hook which "boom.bash"

  path2="${CRENV_TEST_DIR}/etc/crenv_hooks"
  CRENV_HOOK_PATH="$path2"
  create_hook exec "bueno.bash"

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
  CRENV_HOOK_PATH="$path1"
  create_hook exec "hello.bash"
  CRENV_HOOK_PATH="$path2"
  create_hook exec "ahoy.bash"

  CRENV_HOOK_PATH="$path1:$path2" run crenv-hooks exec
  assert_success
  assert_output <<OUT
${CRENV_TEST_DIR}/my hooks/crenv.d/exec/hello.bash
${CRENV_TEST_DIR}/etc/crenv hooks/exec/ahoy.bash
OUT
}

@test "resolves relative paths" {
  CRENV_HOOK_PATH="${CRENV_TEST_DIR}/crenv.d"
  create_hook exec "hello.bash"
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
  touch "${path}/exec/bright.sh"
  ln -s "bright.sh" "${path}/exec/world.bash"

  CRENV_HOOK_PATH="$path" run crenv-hooks exec
  assert_success
  assert_output <<OUT
${HOME}/hola.bash
${CRENV_TEST_DIR}/crenv.d/exec/bright.sh
OUT
}
