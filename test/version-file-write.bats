#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$CRENV_TEST_DIR"
  cd "$CRENV_TEST_DIR"
}

@test "invocation without 2 arguments prints usage" {
  run crenv-version-file-write
  assert_failure "Usage: crenv version-file-write <file> <version>"
  run crenv-version-file-write "one" ""
  assert_failure
}

@test "setting nonexistent version fails" {
  assert [ ! -e ".crystal-version" ]
  run crenv-version-file-write ".crystal-version" "1.8.7"
  assert_failure "crenv: version \`1.8.7' not installed"
  assert [ ! -e ".crystal-version" ]
}

@test "writes value to arbitrary file" {
  mkdir -p "${CRENV_ROOT}/versions/1.8.7"
  assert [ ! -e "my-version" ]
  run crenv-version-file-write "${PWD}/my-version" "1.8.7"
  assert_success ""
  assert [ "$(cat my-version)" = "1.8.7" ]
}
