#!/usr/bin/env bats

load test_helper

create_version() {
  mkdir -p "${CRENV_ROOT}/versions/$1"
}

setup() {
  mkdir -p "$CRENV_TEST_DIR"
  cd "$CRENV_TEST_DIR"
}

@test "no version selected" {
  assert [ ! -d "${CRENV_ROOT}/versions" ]
  run crenv-version
  assert_success "system (set by ${CRENV_ROOT}/version)"
}

@test "set by CRENV_VERSION" {
  create_version "1.9.3"
  CRENV_VERSION=1.9.3 run crenv-version
  assert_success "1.9.3 (set by CRENV_VERSION environment variable)"
}

@test "set by local file" {
  create_version "1.9.3"
  cat > ".crystal-version" <<<"1.9.3"
  run crenv-version
  assert_success "1.9.3 (set by ${PWD}/.crystal-version)"
}

@test "set by global file" {
  create_version "1.9.3"
  cat > "${CRENV_ROOT}/version" <<<"1.9.3"
  run crenv-version
  assert_success "1.9.3 (set by ${CRENV_ROOT}/version)"
}
