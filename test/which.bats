#!/usr/bin/env bats

load test_helper

create_executable() {
  local bin
  if [[ $1 == */* ]]; then bin="$1"
  else bin="${CRENV_ROOT}/versions/${1}/bin"
  fi
  mkdir -p "$bin"
  touch "${bin}/$2"
  chmod +x "${bin}/$2"
}

@test "outputs path to executable" {
  create_executable "1.8" "ruby"
  create_executable "2.0" "rspec"

  CRENV_VERSION=1.8 run crenv-which ruby
  assert_success "${CRENV_ROOT}/versions/1.8/bin/ruby"

  CRENV_VERSION=2.0 run crenv-which rspec
  assert_success "${CRENV_ROOT}/versions/2.0/bin/rspec"
}

@test "searches PATH for system version" {
  create_executable "${CRENV_TEST_DIR}/bin" "kill-all-humans"
  create_executable "${CRENV_ROOT}/shims" "kill-all-humans"

  CRENV_VERSION=system run crenv-which kill-all-humans
  assert_success "${CRENV_TEST_DIR}/bin/kill-all-humans"
}

@test "searches PATH for system version (shims prepended)" {
  create_executable "${CRENV_TEST_DIR}/bin" "kill-all-humans"
  create_executable "${CRENV_ROOT}/shims" "kill-all-humans"

  PATH="${CRENV_ROOT}/shims:$PATH" RBENV_VERSION=system run crenv-which kill-all-humans
  assert_success "${CRENV_TEST_DIR}/bin/kill-all-humans"
}

@test "searches PATH for system version (shims appended)" {
  create_executable "${CRENV_TEST_DIR}/bin" "kill-all-humans"
  create_executable "${CRENV_ROOT}/shims" "kill-all-humans"

  PATH="$PATH:${CRENV_ROOT}/shims" RBENV_VERSION=system run crenv-which kill-all-humans
  assert_success "${CRENV_TEST_DIR}/bin/kill-all-humans"
}

@test "searches PATH for system version (shims spread)" {
  create_executable "${CRENV_TEST_DIR}/bin" "kill-all-humans"
  create_executable "${CRENV_ROOT}/shims" "kill-all-humans"

  PATH="${CRENV_ROOT}/shims:${RBENV_ROOT}/shims:/tmp/non-existent:$PATH:${RBENV_ROOT}/shims" \
    CRENV_VERSION=system run crenv-which kill-all-humans
  assert_success "${CRENV_TEST_DIR}/bin/kill-all-humans"
}

@test "version not installed" {
  create_executable "2.0" "rspec"
  CRENV_VERSION=1.9 run crenv-which rspec
  assert_failure "crenv: version \`1.9' is not installed (set by CRENV_VERSION environment variable)"
}

@test "no executable found" {
  create_executable "1.8" "rspec"
  CRENV_VERSION=1.8 run crenv-which rake
  assert_failure "crenv: rake: command not found"
}

@test "executable found in other versions" {
  create_executable "1.8" "ruby"
  create_executable "1.9" "rspec"
  create_executable "2.0" "rspec"

  CRENV_VERSION=1.8 run crenv-which rspec
  assert_failure
  assert_output <<OUT
crenv: rspec: command not found

The \`rspec' command exists in these Crystal versions:
  1.9
  2.0
OUT
}

@test "carries original IFS within hooks" {
  hook_path="${CRENV_TEST_DIR}/crenv.d"
  mkdir -p "${hook_path}/which"
  cat > "${hook_path}/which/hello.bash" <<SH
hellos=(\$(printf "hello\\tugly world\\nagain"))
echo HELLO="\$(printf ":%s" "\${hellos[@]}")"
exit
SH

  CRENV_HOOK_PATH="$hook_path" IFS=$' \t\n' RBENV_VERSION=system run crenv-which anything
  assert_success
  assert_output "HELLO=:hello:ugly:world:again"
}

@test "discovers version from crenv-version-name" {
  mkdir -p "$CRENV_ROOT"
  cat > "${CRENV_ROOT}/version" <<<"1.8"
  create_executable "1.8" "ruby"

  mkdir -p "$CRENV_TEST_DIR"
  cd "$CRENV_TEST_DIR"

  CRENV_VERSION= run crenv-which ruby
  assert_success "${CRENV_ROOT}/versions/1.8/bin/ruby"
}
