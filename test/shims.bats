#!/usr/bin/env bats

load test_helper

@test "no shims" {
  run crenv-shims
  assert_success
  assert [ -z "$output" ]
}

@test "shims" {
  mkdir -p "${CRENV_ROOT}/shims"
  touch "${CRENV_ROOT}/shims/crystal"
  touch "${CRENV_ROOT}/shims/irb"
  run crenv-shims
  assert_success
  assert_line "${CRENV_ROOT}/shims/crystal"
  assert_line "${CRENV_ROOT}/shims/irb"
}

@test "shims --short" {
  mkdir -p "${CRENV_ROOT}/shims"
  touch "${CRENV_ROOT}/shims/crystal"
  touch "${CRENV_ROOT}/shims/irb"
  run crenv-shims --short
  assert_success
  assert_line "irb"
  assert_line "crystal"
}
