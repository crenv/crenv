#!/usr/bin/env bats

load test_helper

@test "without args shows summary of common commands" {
  run crenv-help
  assert_success
  assert_line "Usage: crenv <command> [<args>]"
  assert_line "Some useful crenv commands are:"
}

@test "invalid command" {
  run crenv-help hello
  assert_failure "crenv: no such command \`hello'"
}

@test "shows help for a specific command" {
  mkdir -p "${CRENV_TEST_DIR}/bin"
  cat > "${CRENV_TEST_DIR}/bin/crenv-hello" <<SH
#!shebang
# Usage: crenv hello <world>
# Summary: Says "hello" to you, from crenv
# This command is useful for saying hello.
echo hello
SH

  run crenv-help hello
  assert_success
  assert_output <<SH
Usage: crenv hello <world>

This command is useful for saying hello.
SH
}

@test "replaces missing extended help with summary text" {
  mkdir -p "${CRENV_TEST_DIR}/bin"
  cat > "${CRENV_TEST_DIR}/bin/crenv-hello" <<SH
#!shebang
# Usage: crenv hello <world>
# Summary: Says "hello" to you, from crenv
echo hello
SH

  run crenv-help hello
  assert_success
  assert_output <<SH
Usage: crenv hello <world>

Says "hello" to you, from crenv
SH
}

@test "extracts only usage" {
  mkdir -p "${CRENV_TEST_DIR}/bin"
  cat > "${CRENV_TEST_DIR}/bin/crenv-hello" <<SH
#!shebang
# Usage: crenv hello <world>
# Summary: Says "hello" to you, from crenv
# This extended help won't be shown.
echo hello
SH

  run crenv-help --usage hello
  assert_success "Usage: crenv hello <world>"
}

@test "multiline usage section" {
  mkdir -p "${CRENV_TEST_DIR}/bin"
  cat > "${CRENV_TEST_DIR}/bin/crenv-hello" <<SH
#!shebang
# Usage: crenv hello <world>
#        crenv hi [everybody]
#        crenv hola --translate
# Summary: Says "hello" to you, from crenv
# Help text.
echo hello
SH

  run crenv-help hello
  assert_success
  assert_output <<SH
Usage: crenv hello <world>
       crenv hi [everybody]
       crenv hola --translate

Help text.
SH
}

@test "multiline extended help section" {
  mkdir -p "${CRENV_TEST_DIR}/bin"
  cat > "${CRENV_TEST_DIR}/bin/crenv-hello" <<SH
#!shebang
# Usage: crenv hello <world>
# Summary: Says "hello" to you, from crenv
# This is extended help text.
# It can contain multiple lines.
#
# And paragraphs.
echo hello
SH

  run crenv-help hello
  assert_success
  assert_output <<SH
Usage: crenv hello <world>

This is extended help text.
It can contain multiple lines.

And paragraphs.
SH
}
