#!/usr/bin/env bats

load test_helper

create_executable() {
  name="${1?}"
  shift 1
  bin="${CRENV_ROOT}/versions/${CRENV_VERSION}/bin"
  mkdir -p "$bin"
  { if [ $# -eq 0 ]; then cat -
    else echo "$@"
    fi
  } | sed -Ee '1s/^ +//' > "${bin}/$name"
  chmod +x "${bin}/$name"
}

@test "fails with invalid version" {
  export CRENV_VERSION="0.10.0"
  run crenv-exec crystal --version
  assert_failure "crenv: version \`0.10.0' is not installed (set by CRENV_VERSION environment variable)"
}

@test "fails with invalid version set from file" {
  mkdir -p "$CRENV_TEST_DIR"
  cd "$CRENV_TEST_DIR"
  echo 0.9.1 > .crystal-version
  run crenv-exec shards
  assert_failure "crenv: version \`0.9.1' is not installed (set by $PWD/.crystal-version)"
}

@test "completes with names of executables" {
  export CRENV_VERSION="0.10.0"
  create_executable "crystal" "#!/bin/sh"
  create_executable "test" "#!/bin/sh"

  crenv-rehash
  run crenv-completions exec
  assert_success
  assert_output <<OUT
crystal
test
OUT
}

@test "supports hook path with spaces" {
  hook_path="${CRENV_TEST_DIR}/custom stuff/crenv hooks"
  mkdir -p "${hook_path}/exec"
  echo "export HELLO='from hook'" > "${hook_path}/exec/hello.bash"

  export CRENV_VERSION=system
  CRENV_HOOK_PATH="$hook_path" run crenv-exec env
  assert_success
  assert_line "HELLO=from hook"
}

@test "carries original IFS within hooks" {
  hook_path="${CRENV_TEST_DIR}/crenv.d"
  mkdir -p "${hook_path}/exec"
  cat > "${hook_path}/exec/hello.bash" <<SH
hellos=(\$(printf "hello\\tugly world\\nagain"))
echo HELLO="\$(printf ":%s" "\${hellos[@]}")"
SH

  export CRENV_VERSION=system
  CRENV_HOOK_PATH="$hook_path" IFS=$' \t\n' run crenv-exec env
  assert_success
  assert_line "HELLO=:hello:ugly:world:again"
}

@test "forwards all arguments" {
  export CRENV_VERSION="0.10.0"
  create_executable "crystal" <<SH
#!$BASH
echo \$0
for arg; do
  # hack to avoid bash builtin echo which can't output '-e'
  printf "  %s\\n" "\$arg"
done
SH

  run crenv-exec crystal -w "/path to/crystal script.rb" -- extra args
  assert_success
  assert_output <<OUT
${CRENV_ROOT}/versions/0.10.0/bin/crystal
  -w
  /path to/crystal script.rb
  --
  extra
  args
OUT
}

