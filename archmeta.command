#!/bin/sh
# Finder double-click entry point.
#
# A .command opened from Finder inherits Terminal's working directory — the
# user's home folder — not the directory this file sits in. Falling through to
# archmeta.sh's $PWD default would therefore mount all of $HOME as the
# architecture repository. Resolve the repo from this file's own location
# instead: the launcher is meant to sit in (or beside) the repository.
DIR="$(cd "$(dirname "$0")" && pwd)"

# This file is a wrapper; the logic lives in archmeta.sh. Copying one without
# the other is the obvious mistake, so say so rather than leaving the shell to
# report a missing file.
if [ ! -f "$DIR/archmeta.sh" ]; then
  echo "archmeta.sh is not next to this launcher (looked in $DIR)." >&2
  echo >&2
  echo "The double-click launcher is a pair of files. Either copy archmeta.sh" >&2
  echo "here as well, or start ArchMeta from a terminal with the repository" >&2
  echo "path as an argument:" >&2
  echo >&2
  echo "  /path/to/archmeta.sh \"$DIR\"" >&2
  exit 1
fi

exec "$DIR/archmeta.sh" "${1:-$DIR}"
