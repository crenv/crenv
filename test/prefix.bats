#!/usr/bin/env bats

load test_helper

@test "prefix" {
  mkdir -p "${CRENV_TEST_DIR}/myproject"
  cd "${CRENV_TEST_DIR}/myproject"
  echo "1.2.3" > .crystal-version
  mkdir -p "${CRENV_ROOT}/versions/1.2.3"
  run crenv-prefix
  assert_success "${CRENV_ROOT}/versions/1.2.3"
}

@test "prefix for invalid version" {
  CRENV_VERSION="1.2.3" run crenv-prefix
  assert_failure "crenv: version \`1.2.3' not installed"
}

@test "prefix for system" {
  mkdir -p "${CRENV_TEST_DIR}/bin"
  touch "${CRENV_TEST_DIR}/bin/crystal"
  chmod +x "${CRENV_TEST_DIR}/bin/crystal"
  CRENV_VERSION="system" run crenv-prefix
  assert_success "$CRENV_TEST_DIR"
}

@test "prefix for invalid system" {
  PATH="$(path_without crystal)" run crenv-prefix system
  assert_failure "crenv: system version not found in PATH"
}
