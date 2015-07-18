#!/usr/bin/env bats

load test_helper

@test "creates shims and versions directories" {
  assert [ ! -d "${CRENV_ROOT}/shims" ]
  assert [ ! -d "${CRENV_ROOT}/versions" ]
  run crenv-init -
  assert_success
  assert [ -d "${CRENV_ROOT}/shims" ]
  assert [ -d "${CRENV_ROOT}/versions" ]
}

@test "auto rehash" {
  run crenv-init -
  assert_success
  assert_line "crenv rehash 2>/dev/null"
}

@test "setup shell completions" {
  root="$(cd $BATS_TEST_DIRNAME/.. && pwd)"
  run crenv-init - bash
  assert_success
  assert_line "source '${root}/test/../libexec/../completions/crenv.bash'"
}

@test "detect parent shell" {
  root="$(cd $BATS_TEST_DIRNAME/.. && pwd)"
  SHELL=/bin/false run crenv-init -
  assert_success
  assert_line "export CRENV_SHELL=bash"
}

@test "setup shell completions (fish)" {
  root="$(cd $BATS_TEST_DIRNAME/.. && pwd)"
  run crenv-init - fish
  assert_success
  assert_line ". '${root}/test/../libexec/../completions/crenv.fish'"
}

@test "fish instructions" {
  run crenv-init fish
  assert [ "$status" -eq 1 ]
  assert_line 'status --is-interactive; and . (crenv init -|psub)'
}

@test "option to skip rehash" {
  run crenv-init - --no-rehash
  assert_success
  refute_line "crenv rehash 2>/dev/null"
}

@test "adds shims to PATH" {
  export PATH="${BATS_TEST_DIRNAME}/../libexec:/usr/bin:/bin:/usr/local/bin"
  run crenv-init - bash
  assert_success
  assert_line 0 'export PATH="'${CRENV_ROOT}'/shims:${PATH}"'
}

@test "adds shims to PATH (fish)" {
  export PATH="${BATS_TEST_DIRNAME}/../libexec:/usr/bin:/bin:/usr/local/bin"
  run crenv-init - fish
  assert_success
  assert_line 0 "setenv PATH '${CRENV_ROOT}/shims' \$PATH"
}

@test "can add shims to PATH more than once" {
  export PATH="${CRENV_ROOT}/shims:$PATH"
  run crenv-init - bash
  assert_success
  assert_line 0 'export PATH="'${CRENV_ROOT}'/shims:${PATH}"'
}

@test "can add shims to PATH more than once (fish)" {
  export PATH="${CRENV_ROOT}/shims:$PATH"
  run crenv-init - fish
  assert_success
  assert_line 0 "setenv PATH '${CRENV_ROOT}/shims' \$PATH"
}

@test "outputs sh-compatible syntax" {
  run crenv-init - bash
  assert_success
  assert_line '  case "$command" in'

  run crenv-init - zsh
  assert_success
  assert_line '  case "$command" in'
}

@test "outputs fish-specific syntax (fish)" {
  run crenv-init - fish
  assert_success
  assert_line '  switch "$command"'
  refute_line '  case "$command" in'
}
