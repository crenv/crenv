#!/usr/bin/env bats

load test_helper

@test "blank invocation" {
  run crenv
  assert_success
  assert [ "${lines[0]}" = "crenv 0.1.2" ]
}

@test "invalid command" {
  run crenv does-not-exist
  assert_failure
  assert_output "crenv: no such command \`does-not-exist'"
}

@test "default CRENV_ROOT" {
  CRENV_ROOT="" HOME=/home/mislav run crenv root
  assert_success
  assert_output "/home/mislav/.crenv"
}

@test "inherited CRENV_ROOT" {
  CRENV_ROOT=/opt/crenv run crenv root
  assert_success
  assert_output "/opt/crenv"
}

@test "default CRENV_DIR" {
  run crenv echo CRENV_DIR
  assert_output "$(pwd)"
}

@test "inherited CRENV_DIR" {
  dir="${BATS_TMPDIR}/myproject"
  mkdir -p "$dir"
  CRENV_DIR="$dir" run crenv echo CRENV_DIR
  assert_output "$dir"
}

@test "invalid CRENV_DIR" {
  dir="${BATS_TMPDIR}/does-not-exist"
  assert [ ! -d "$dir" ]
  CRENV_DIR="$dir" run crenv echo CRENV_DIR
  assert_failure
  assert_output "crenv: cannot change working directory to \`$dir'"
}

@test "adds its own libexec to PATH" {
  run crenv echo "PATH"
  assert_success "${BATS_TEST_DIRNAME%/*}/libexec:$PATH"
}

@test "adds plugin bin dirs to PATH" {
  mkdir -p "$CRENV_ROOT"/plugins/crystal-build/bin
  mkdir -p "$CRENV_ROOT"/plugins/crenv-each/bin
  run crenv echo -F: "PATH"
  assert_success
  assert_line 0 "${BATS_TEST_DIRNAME%/*}/libexec"
  assert_line 1 "${CRENV_ROOT}/plugins/crystal-build/bin"
  assert_line 2 "${CRENV_ROOT}/plugins/crenv-each/bin"
}

@test "CRENV_HOOK_PATH preserves value from environment" {
  CRENV_HOOK_PATH=/my/hook/path:/other/hooks run crenv echo -F: "CRENV_HOOK_PATH"
  assert_success
  assert_line 0 "/my/hook/path"
  assert_line 1 "/other/hooks"
  assert_line 2 "${CRENV_ROOT}/crenv.d"
}

@test "CRENV_HOOK_PATH includes crenv built-in plugins" {
  run crenv echo "CRENV_HOOK_PATH"
  assert_success ":${CRENV_ROOT}/crenv.d:${BATS_TEST_DIRNAME%/*}/crenv.d:/usr/local/etc/crenv.d:/etc/crenv.d:/usr/lib/crenv/hooks"
}
