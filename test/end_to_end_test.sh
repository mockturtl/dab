#!/bin/sh -e

f="$1"
pkg="path"

dart bin/dab.dart dep "$pkg" -f "$f"

output="$(git --no-pager diff -U0 "$f" | tail -n +6)"

if [ "$output" != "+  $pkg: ^1.6.2" ]; then
  return 11
fi
