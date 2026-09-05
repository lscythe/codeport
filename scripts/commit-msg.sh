#!/bin/sh
msg_file="$1"
subject=$(head -n1 "$msg_file")

if ! printf '%s' "$subject" | grep -Eq '^(feat|fix|chore|refactor|test|docs|style|ci|build)\([a-z0-9_-]+\): .+[^.]$'; then
  echo "Invalid commit message: \"$subject\""
  echo "Expected: <type>(<scope>): <short summary>"
  echo "Types: feat|fix|chore|refactor|test|docs|style|ci|build"
  exit 1
fi
