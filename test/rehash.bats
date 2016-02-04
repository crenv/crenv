#!/usr/bin/env bats

load test_helper

create_executable() {
  local bin="${CRENV_ROOT}/versions/${1}/bin"
  mkdir -p "$bin"
  touch "${bin}/$2"
  chmod +x "${bin}/$2"
}

@test "empty rehash" {
  assert [ ! -d "${CRENV_ROOT}/shims" ]
  run crenv-rehash
  assert_success ""
  assert [ -d "${CRENV_ROOT}/shims" ]
  rmdir "${CRENV_ROOT}/shims"
}

@test "non-writable shims directory" {
  mkdir -p "${CRENV_ROOT}/shims"
  chmod -w "${CRENV_ROOT}/shims"
  run crenv-rehash
  assert_failure "crenv: cannot rehash: ${CRENV_ROOT}/shims isn't writable"
}

@test "rehash in progress" {
  mkdir -p "${CRENV_ROOT}/shims"
  touch "${CRENV_ROOT}/shims/.crenv-shim"
  run crenv-rehash
  assert_failure "crenv: cannot rehash: ${CRENV_ROOT}/shims/.crenv-shim exists"
}

@test "creates shims" {
  create_executable "1.8" "crystal"
  create_executable "1.8" "rake"
  create_executable "2.0" "crystal"
  create_executable "2.0" "rspec"

  assert [ ! -e "${CRENV_ROOT}/shims/crystal" ]
  assert [ ! -e "${CRENV_ROOT}/shims/rake" ]
  assert [ ! -e "${CRENV_ROOT}/shims/rspec" ]

  run crenv-rehash
  assert_success ""

  run ls "${CRENV_ROOT}/shims"
  assert_success
  assert_output <<OUT
crystal
rake
rspec
OUT
}

@test "removes outdated shims" {
  mkdir -p "${CRENV_ROOT}/shims"
  touch "${CRENV_ROOT}/shims/oldshim1"
  chmod +x "${CRENV_ROOT}/shims/oldshim1"

  create_executable "2.0" "rake"
  create_executable "2.0" "crystal"

  run crenv-rehash
  assert_success ""

  assert [ ! -e "${CRENV_ROOT}/shims/oldshim1" ]
}

@test "do exact matches when removing stale shims" {
  create_executable "2.0" "unicorn_rails"
  create_executable "2.0" "rspec-core"

  crenv-rehash

  cp "$CRENV_ROOT"/shims/{rspec-core,rspec}
  cp "$CRENV_ROOT"/shims/{rspec-core,rails}
  cp "$CRENV_ROOT"/shims/{rspec-core,uni}
  chmod +x "$CRENV_ROOT"/shims/{rspec,rails,uni}

  run crenv-rehash
  assert_success ""

  assert [ ! -e "${CRENV_ROOT}/shims/rails" ]
  assert [ ! -e "${CRENV_ROOT}/shims/rake" ]
  assert [ ! -e "${CRENV_ROOT}/shims/uni" ]
}

@test "binary install locations containing spaces" {
  create_executable "dirname1 p247" "crystal"
  create_executable "dirname2 preview1" "rspec"

  assert [ ! -e "${CRENV_ROOT}/shims/crystal" ]
  assert [ ! -e "${CRENV_ROOT}/shims/rspec" ]

  run crenv-rehash
  assert_success ""

  run ls "${CRENV_ROOT}/shims"
  assert_success
  assert_output <<OUT
crystal
rspec
OUT
}

@test "carries original IFS within hooks" {
  create_hook rehash hello.bash <<SH
hellos=(\$(printf "hello\\tugly world\\nagain"))
echo HELLO="\$(printf ":%s" "\${hellos[@]}")"
exit
SH

  IFS=$' \t\n' run crenv-rehash
  assert_success
  assert_output "HELLO=:hello:ugly:world:again"
}

@test "sh-rehash in bash" {
  create_executable "2.0" "crystal"
  CRENV_SHELL=bash run crenv-sh-rehash
  assert_success "hash -r 2>/dev/null || true"
  assert [ -x "${CRENV_ROOT}/shims/crystal" ]
}

@test "sh-rehash in fish" {
  create_executable "2.0" "crystal"
  CRENV_SHELL=fish run crenv-sh-rehash
  assert_success ""
  assert [ -x "${CRENV_ROOT}/shims/crystal" ]
}
