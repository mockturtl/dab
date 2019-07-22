#!/bin/bash -e

file="pubspec.yaml"
version=$(sed -n "s|\s*version: \([0-9]\.[0-9]\.[0-9].*\)\s*|\1|p" "$file")

cat<<-EOF
  Tagging version $version...
EOF

git add --patch "$file"

git commit -m "[ann] v$version"

git tag "$version"

git push && git push --tags
