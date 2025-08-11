#!/usr/bin/env bash

set -e

to_snake_case() {
  sed 's/\([a-z0-9]\)\([A-Z]\)/\1_\2/g' | tr '[:upper:]' '[:lower:]' | sed 's/[ -]/_/g'
}

if [ $# -gt 0 ]; then
  echo "$*" | to_snake_case
else
  to_snake_case
fi
