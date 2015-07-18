#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "${CRENV_TEST_DIR}/myproject"
  cd "${CRENV_TEST_DIR}/myproject"
}

@test "no version" {
  assert [ ! -e "${PWD}/.crystal-version" ]
  run crenv-local
  assert_failure "crenv: no local version configured for this directory"
}

@test "local version" {
  echo "1.2.3" > .crystal-version
  run crenv-local
  assert_success "1.2.3"
}

@test "supports legacy .crenv-version file" {
  echo "1.2.3" > .crenv-version
  run crenv-local
  assert_success "1.2.3"
}

@test "local .crystal-version has precedence over .crenv-version" {
  echo "1.8" > .crenv-version
  echo "2.0" > .crystal-version
  run crenv-local
  assert_success "2.0"
}

@test "ignores version in parent directory" {
  echo "1.2.3" > .crystal-version
  mkdir -p "subdir" && cd "subdir"
  run crenv-local
  assert_failure
}

@test "ignores CRENV_DIR" {
  echo "1.2.3" > .crystal-version
  mkdir -p "$HOME"
  echo "2.0-home" > "${HOME}/.crystal-version"
  CRENV_DIR="$HOME" run crenv-local
  assert_success "1.2.3"
}

@test "sets local version" {
  mkdir -p "${CRENV_ROOT}/versions/1.2.3"
  run crenv-local 1.2.3
  assert_success ""
  assert [ "$(cat .crystal-version)" = "1.2.3" ]
}

@test "changes local version" {
  echo "1.0-pre" > .crystal-version
  mkdir -p "${CRENV_ROOT}/versions/1.2.3"
  run crenv-local
  assert_success "1.0-pre"
  run crenv-local 1.2.3
  assert_success ""
  assert [ "$(cat .crystal-version)" = "1.2.3" ]
}

@test "renames .crenv-version to .crystal-version" {
  echo "1.8.7" > .crenv-version
  mkdir -p "${CRENV_ROOT}/versions/1.9.3"
  run crenv-local
  assert_success "1.8.7"
  run crenv-local "1.9.3"
  assert_success
  assert_output <<OUT
crenv: removed existing \`.crenv-version' file and migrated
       local version specification to \`.crystal-version' file
OUT
  assert [ ! -e .crenv-version ]
  assert [ "$(cat .crystal-version)" = "1.9.3" ]
}

@test "doesn't rename .crenv-version if changing the version failed" {
  echo "1.8.7" > .crenv-version
  assert [ ! -e "${CRENV_ROOT}/versions/1.9.3" ]
  run crenv-local "1.9.3"
  assert_failure "crenv: version \`1.9.3' not installed"
  assert [ ! -e .crystal-version ]
  assert [ "$(cat .crenv-version)" = "1.8.7" ]
}

@test "unsets local version" {
  touch .crystal-version
  run crenv-local --unset
  assert_success ""
  assert [ ! -e .crenv-version ]
}

@test "unsets alternate version file" {
  touch .crenv-version
  run crenv-local --unset
  assert_success ""
  assert [ ! -e .crenv-version ]
}
