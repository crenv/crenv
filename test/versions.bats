#!/usr/bin/env bats

load test_helper

create_version() {
  mkdir -p "${CRENV_ROOT}/versions/$1"
}

setup() {
  mkdir -p "$CRENV_TEST_DIR"
  cd "$CRENV_TEST_DIR"
}

stub_system_crystal() {
  local stub="${CRENV_TEST_DIR}/bin/crystal"
  mkdir -p "$(dirname "$stub")"
  touch "$stub" && chmod +x "$stub"
}

@test "no versions installed" {
  stub_system_crystal
  assert [ ! -d "${CRENV_ROOT}/versions" ]
  run crenv-versions
  assert_success "* system (set by ${CRENV_ROOT}/version)"
}

@test "not even system crystal available" {
  PATH="$(path_without crystal)" run crenv-versions
  assert_failure
  assert_output "Warning: no Crystal detected on the system"
}

@test "bare output no versions installed" {
  assert [ ! -d "${CRENV_ROOT}/versions" ]
  run crenv-versions --bare
  assert_success ""
}

@test "single version installed" {
  stub_system_crystal
  create_version "1.9"
  run crenv-versions
  assert_success
  assert_output <<OUT
* system (set by ${CRENV_ROOT}/version)
  1.9
OUT
}

@test "single version bare" {
  create_version "1.9"
  run crenv-versions --bare
  assert_success "1.9"
}

@test "multiple versions" {
  stub_system_crystal
  create_version "1.8.7"
  create_version "1.9.3"
  create_version "2.0.0"
  run crenv-versions
  assert_success
  assert_output <<OUT
* system (set by ${CRENV_ROOT}/version)
  1.8.7
  1.9.3
  2.0.0
OUT
}

@test "indicates current version" {
  stub_system_crystal
  create_version "1.9.3"
  create_version "2.0.0"
  CRENV_VERSION=1.9.3 run crenv-versions
  assert_success
  assert_output <<OUT
  system
* 1.9.3 (set by CRENV_VERSION environment variable)
  2.0.0
OUT
}

@test "bare doesn't indicate current version" {
  create_version "1.9.3"
  create_version "2.0.0"
  CRENV_VERSION=1.9.3 run crenv-versions --bare
  assert_success
  assert_output <<OUT
1.9.3
2.0.0
OUT
}

@test "globally selected version" {
  stub_system_crystal
  create_version "1.9.3"
  create_version "2.0.0"
  cat > "${CRENV_ROOT}/version" <<<"1.9.3"
  run crenv-versions
  assert_success
  assert_output <<OUT
  system
* 1.9.3 (set by ${CRENV_ROOT}/version)
  2.0.0
OUT
}

@test "per-project version" {
  stub_system_crystal
  create_version "1.9.3"
  create_version "2.0.0"
  cat > ".crystal-version" <<<"1.9.3"
  run crenv-versions
  assert_success
  assert_output <<OUT
  system
* 1.9.3 (set by ${CRENV_TEST_DIR}/.crystal-version)
  2.0.0
OUT
}

@test "ignores non-directories under versions" {
  create_version "1.9"
  touch "${CRENV_ROOT}/versions/hello"

  run crenv-versions --bare
  assert_success "1.9"
}

@test "lists symlinks under versions" {
  create_version "1.8.7"
  ln -s "1.8.7" "${CRENV_ROOT}/versions/1.8"

  run crenv-versions --bare
  assert_success
  assert_output <<OUT
1.8
1.8.7
OUT
}

@test "doesn't list symlink aliases when --skip-aliases" {
  create_version "0.7.1"
  ln -s "0.7.1" "${CRENV_ROOT}/versions/0.7"
  mkdir moo
  ln -s "${PWD}/moo" "${CRENV_ROOT}/versions/0.8"

  run crenv-versions --bare --skip-aliases
  assert_success

  assert_output <<OUT
0.7.1
0.8
OUT
}
