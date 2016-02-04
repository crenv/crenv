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
  run crenv-version-name
  assert_success "system"
}

@test "system version is not checked for existance" {
  crenv_version=system run crenv-version-name
  assert_success "system"
}

@test "CRENV_VERSION can be overriden by hook " {
  create_version "0.11.0"
  create_version "0.11.1"
  create_hook version-name test.bash <<<"CRENV_VERSION=0.11.1"

  CRENV_VERSION=0.11.0 run crenv-version-name
  assert_success "0.11.1"
}

@test "CRENV_VERSION has precedence over local" {
  create_version "1.8.7"
  create_version "1.9.3"

  cat > ".crystal-version" <<<"1.8.7"
  run crenv-version-name
  assert_success "1.8.7"

  CRENV_VERSION=1.9.3 run crenv-version-name
  assert_success "1.9.3"
}

@test "local file has precedence over global" {
  create_version "1.8.7"
  create_version "1.9.3"

  cat > "${CRENV_ROOT}/version" <<<"1.8.7"
  run crenv-version-name
  assert_success "1.8.7"

  cat > ".crystal-version" <<<"1.9.3"
  run crenv-version-name
  assert_success "1.9.3"
}

@test "missing version" {
  CRENV_VERSION=1.2 run crenv-version-name
  assert_failure "crenv: version \`1.2' is not installed (set by CRENV_VERSION environment variable)"
}

@test "version with prefix in name" {
  create_version "1.8.7"
  cat > ".crystal-version" <<<"crystal-1.8.7"
  run crenv-version-name
  assert_success
  assert_output <<SH
warning: ignoring extraneous \`crystal-' prefix in version \`crystal-1.8.7'
1.8.7
SH
}
