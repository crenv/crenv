#!/usr/bin/env bats

load test_helper

export GIT_DIR="${CRENV_TEST_DIR}/.git"

# points to /tmp/crenv/home/.gitconfig
export GIT_CONFIG="$HOME/.gitconfig"

setup() {
  mkdir -p "$HOME"
  git config user.name  "Tester"
  git config user.email "tester@test.local"
  cd "$CRENV_TEST_DIR"
}

git_commit() {
  git commit --quiet --allow-empty -m "empty"
}

@test "default version" {
  assert [ ! -e "$CRENV_ROOT" ]
  run crenv---version
  assert_success
  [[ $output == "crenv "?.?.? ]]
}

@test "reads version from git repo" {
  git init
  git remote add origin https://github.com/pine/crenv.git
  git_commit
  git tag v0.4.1
  git_commit
  git_commit

  run crenv---version
  assert_success "crenv 0.4.1-2-g$(git rev-parse --short HEAD)"
}

@test "prints default version if no tags in git repo" {
  git init
  git remote add origin https://github.com/pine/crenv.git
  git_commit

  cd "$CRENV_TEST_DIR"
  run crenv---version
  [[ $output == "crenv "?.?.? ]]
}
