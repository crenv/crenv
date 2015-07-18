#!/usr/bin/env bats

load test_helper

@test "no shell version" {
  mkdir -p "${CRENV_TEST_DIR}/myproject"
  cd "${CRENV_TEST_DIR}/myproject"
  echo "1.2.3" > .crystal-version
  CRENV_VERSION="" run crenv-sh-shell
  assert_failure "crenv: no shell-specific version configured"
}

@test "shell version" {
  CRENV_SHELL=bash CRENV_VERSION="1.2.3" run crenv-sh-shell
  assert_success 'echo "$CRENV_VERSION"'
}

@test "shell version (fish)" {
  CRENV_SHELL=fish CRENV_VERSION="1.2.3" run crenv-sh-shell
  assert_success 'echo "$CRENV_VERSION"'
}

@test "shell unset" {
  CRENV_SHELL=bash run crenv-sh-shell --unset
  assert_success "unset CRENV_VERSION"
}

@test "shell unset (fish)" {
  CRENV_SHELL=fish run crenv-sh-shell --unset
  assert_success "set -e CRENV_VERSION"
}

@test "shell change invalid version" {
  run crenv-sh-shell 1.2.3
  assert_failure
  assert_output <<SH
crenv: version \`1.2.3' not installed
false
SH
}

@test "shell change version" {
  mkdir -p "${CRENV_ROOT}/versions/1.2.3"
  CRENV_SHELL=bash run crenv-sh-shell 1.2.3
  assert_success 'export CRENV_VERSION="1.2.3"'
}

@test "shell change version (fish)" {
  mkdir -p "${CRENV_ROOT}/versions/1.2.3"
  CRENV_SHELL=fish run crenv-sh-shell 1.2.3
  assert_success 'setenv CRENV_VERSION "1.2.3"'
}
