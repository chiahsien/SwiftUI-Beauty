#!/bin/bash

GIT_ROOT=$(git rev-parse --show-toplevel)
HOOKS_PATH=$(git rev-parse --git-dir)/hooks

if [ ! -d "$HOOKS_PATH" ]; then
  mkdir "$HOOKS_PATH"
fi

ln -s -f "$GIT_ROOT/Scripts/pre-commit.sh" "$HOOKS_PATH/pre-commit"
chmod +x "$HOOKS_PATH/pre-commit"

echo "git hooks installed!"
