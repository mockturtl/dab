#!/bin/sh -e

f="$1"

dart bin/dab.dart dep path -f "$f"

git --no-pager diff "$f"
