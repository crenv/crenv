#!/usr/bin/env bats

load test_helper

@test "default" {
  run crenv global
  assert_success
  assert_output "system"
}

@test "read CRENV_ROOT/version" {
  mkdir -p "$CRENV_ROOT"
  echo "1.2.3" > "$CRENV_ROOT/version"
  run crenv-global
  assert_success
  assert_output "1.2.3"
}

@test "set CRENV_ROOT/version" {
  mkdir -p "$CRENV_ROOT/versions/1.2.3"
  run crenv-global "1.2.3"
  assert_success
  run crenv global
  assert_success "1.2.3"
}

@test "fail setting invalid CRENV_ROOT/version" {
  mkdir -p "$CRENV_ROOT"
  run crenv-global "1.2.3"
  assert_failure "crenv: version \`1.2.3' not installed"
}
