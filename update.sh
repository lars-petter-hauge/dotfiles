#!/usr/bin/env bash

COUNT="$1"

for ((i = 1; i <= COUNT; i++)); do
  rand=$(shuf -n 1 /usr/share/dict/words)
  sed -i "s/{[^}]*}/{ $rand }/g" content
  git add content
  git commit -m "Update random word to: $rand"

  echo "Commit $i: set word to '$rand'"
done
