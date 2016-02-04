#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$CRENV_TEST_DIR"
  cd "$CRENV_TEST_DIR"
}

@test "reports global file even if it doesn't exist" {
  assert [ ! -e "${CRENV_ROOT}/version" ]
  run crenv-version-origin
  assert_success "${CRENV_ROOT}/version"
}

@test "detects global file" {
  mkdir -p "$CRENV_ROOT"
  touch "${CRENV_ROOT}/version"
  run crenv-version-origin
  assert_success "${CRENV_ROOT}/version"
}

@test "detects CRENV_VERSION" {
  CRENV_VERSION=1 run crenv-version-origin
  assert_success "CRENV_VERSION environment variable"
}

@test "detects local file" {
  touch .crystal-version
  run crenv-version-origin
  assert_success "${PWD}/.crystal-version"
}

@test "detects alternate version file" {
  touch .crenv-version
  run crenv-version-origin
  assert_success "${PWD}/.crenv-version"
}

@test "reports from hook" {
  create_hook version-origin test.bash <<<"CRENV_VERSION_ORIGIN=plugin"

  CRENV_VERSION=1 run crenv-version-origin
  assert_success "plugin"
}
