#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$CRENV_TEST_DIR"
  cd "$CRENV_TEST_DIR"
}

create_file() {
  mkdir -p "$(dirname "$1")"
  touch "$1"
}

@test "prints global file if no version files exist" {
  assert [ ! -e "${CRENV_ROOT}/version" ]
  assert [ ! -e ".crystal-version" ]
  run crenv-version-file
  assert_success "${CRENV_ROOT}/version"
}

@test "detects 'global' file" {
  create_file "${CRENV_ROOT}/global"
  run crenv-version-file
  assert_success "${CRENV_ROOT}/global"
}

@test "detects 'default' file" {
  create_file "${CRENV_ROOT}/default"
  run crenv-version-file
  assert_success "${CRENV_ROOT}/default"
}

@test "'version' has precedence over 'global' and 'default'" {
  create_file "${CRENV_ROOT}/version"
  create_file "${CRENV_ROOT}/global"
  create_file "${CRENV_ROOT}/default"
  run crenv-version-file
  assert_success "${CRENV_ROOT}/version"
}

@test "in current directory" {
  create_file ".crystal-version"
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/.crystal-version"
}

@test "legacy file in current directory" {
  create_file ".crenv-version"
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/.crenv-version"
}

@test ".crystal-version has precedence over legacy file" {
  create_file ".crystal-version"
  create_file ".crenv-version"
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/.crystal-version"
}

@test "in parent directory" {
  create_file ".crystal-version"
  mkdir -p project
  cd project
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/.crystal-version"
}

@test "topmost file has precedence" {
  create_file ".crystal-version"
  create_file "project/.crystal-version"
  cd project
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/project/.crystal-version"
}

@test "legacy file has precedence if higher" {
  create_file ".crystal-version"
  create_file "project/.crenv-version"
  cd project
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/project/.crenv-version"
}

@test "CRENV_DIR has precedence over PWD" {
  create_file "widget/.crystal-version"
  create_file "project/.crystal-version"
  cd project
  CRENV_DIR="${CRENV_TEST_DIR}/widget" run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/widget/.crystal-version"
}

@test "PWD is searched if CRENV_DIR yields no results" {
  mkdir -p "widget/blank"
  create_file "project/.crystal-version"
  cd project
  CRENV_DIR="${CRENV_TEST_DIR}/widget/blank" run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/project/.crystal-version"
}
