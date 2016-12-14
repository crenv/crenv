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

@test "detects global 'version' file" {
  create_file "${CRENV_ROOT}/version"
  run crenv-version-file
  assert_success "${CRENV_ROOT}/version"
}

@test "prints global file if no version files exist" {
  assert [ ! -e "${CRENV_ROOT}/version" ]
  assert [ ! -e ".crystal-version" ]
  run crenv-version-file
  assert_success "${CRENV_ROOT}/version"
}

@test "in current directory" {
  create_file ".crystal-version"
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/.crystal-version"
}

@test "in current directory (shard.yml)" {
  assert [ ! -e "${CRENV_ROOT}/version" ]
  assert [ ! -e ".crystal-version" ]

  create_file "project/shard.yml"
  cd project
  cat > shard.yml <<< "crystal: 0.20.1"
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/project/shard.yml"
}

@test "in current directory but invalid file (shard.yml)" {
  create_file "project/shard.yml"
  cd project
  cat > shard.yml <<< "name: foo"
  run crenv-version-file
  assert_success "${CRENV_ROOT}/version"
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

@test ".crystal-version has precedence over shard.yml file" {
  create_file ".crystal-version"
  create_file "shard.yml"
  cat > shard.yml <<< "crystal: 0.20.1"
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/.crystal-version"
}

@test "shard.yml has precedence over global version" {
  create_file "${CRENV_ROOT}/version"
  create_file "shard.yml"
  cat > shard.yml <<< "crystal: 0.20.1"
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/shard.yml"
}

@test "in parent directory" {
  create_file ".crystal-version"
  mkdir -p project
  cd project
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/.crystal-version"
}

@test "in parent directory (shard.yml)" {
  create_file "shard.yml"
  cat > shard.yml <<< "crystal: 0.20.1"
  mkdir -p project
  cd project
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/shard.yml"
}

@test "topmost file has precedence" {
  create_file ".crystal-version"
  create_file "project/.crystal-version"
  cd project
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/project/.crystal-version"
}

@test "topmost file has precedence (shard.yml)" {
  create_file "shard.yml"
  create_file "project/shard.yml"
  cat > "shard.yml" <<< "crystal: 0.20.1"
  cat > "project/shard.yml" <<< "crystal: 0.20.1"
  cd project
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/project/shard.yml"
}

@test "legacy file has precedence if higher" {
  create_file ".crystal-version"
  create_file "project/.crenv-version"
  cd project
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/project/.crenv-version"
}

@test "legacy file has precedence if higher (shard.yml)" {
  create_file "shard.yml"
  create_file "project/.crenv-version"
  cat > "shard.yml" <<< "crystal: 0.20.1"
  cd project
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/project/.crenv-version"
}

@test ".crystal-version file has precedence if higher (shard.yml)" {
  create_file "shard.yml"
  create_file "project/.crystal-version"
  cat > "shard.yml" <<< "crystal: 0.20.1"
  cd project
  run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/project/.crystal-version"
}

@test "CRENV_DIR has precedence over PWD" {
  create_file "widget/.crystal-version"
  create_file "project/.crystal-version"
  cd project
  CRENV_DIR="${CRENV_TEST_DIR}/widget" run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/widget/.crystal-version"
}

@test "CRENV_DIR has precedence over PWD (shard.yml)" {
  create_file "widget/shard.yml"
  create_file "project/shard.yml"
  cat > "widget/shard.yml" <<< "crystal: 0.20.1"
  cat > "project/shard.yml" <<< "crystal: 0.20.1"
  cd project
  CRENV_DIR="${CRENV_TEST_DIR}/widget" run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/widget/shard.yml"
}

@test "CRENV_DIR has precedence over PWD (invalid shard.yml file)" {
  create_file "widget/shard.yml"
  create_file "project/shard.yml"
  cat > "widget/shard.yml" <<< "name: foo"
  cat > "project/shard.yml" <<< "crystal: 0.20.1"
  cd project
  CRENV_DIR="${CRENV_TEST_DIR}/widget" run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/project/shard.yml"
}

@test "PWD is searched if CRENV_DIR yields no results" {
  mkdir -p "widget/blank"
  create_file "project/.crystal-version"
  cd project
  CRENV_DIR="${CRENV_TEST_DIR}/widget/blank" run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/project/.crystal-version"
}

@test "PWD is searched if CRENV_DIR yields no results (shard.yml)" {
  mkdir -p "widget/blank"
  create_file "project/shard.yml"
  cat > "project/shard.yml" <<< "crystal: 0.20.1"
  cd project
  CRENV_DIR="${CRENV_TEST_DIR}/widget/blank" run crenv-version-file
  assert_success "${CRENV_TEST_DIR}/project/shard.yml"
}
