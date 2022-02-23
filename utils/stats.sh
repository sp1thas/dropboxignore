#!/usr/bin/env bash

set -eux

dir="$(mktemp -d)"
cd "$dir"

git clone "https://x-access-token:${0}@github.com/sp1thas/dropboxignore.wiki.git" .

MANUAL_INSTALLATIONS=$(curl -s https://api.countapi.xyz/info/dropboxignore.simakis.me/total | jq -r .value)
SNAP_INSTALLATIONS=$(snapcraft metrics dropboxignore --name installed_base_by_channel --start $(date +"%Y-%m-%d" --date="yesterday") --end $(date +"%Y-%m-%d" --date="yesterday") --format=json | jq '.series[].values[]' | awk '{s+=$1} END {printf "%.0f\n", s}')
TOTAL_INSTALLATIONS=$(($MANUAL_INSTALLATIONS + $SNAP_INSTALLATIONS))
JSON_STRING=$(
  cat <<-END
{"schemaVersion": 1, "label": "installations", "message": "$TOTAL_INSTALLATIONS"}
END
)
echo "$JSON_STRING" >stats.json

git add stats.json

if ! git diff --staged --exit-code; then
  git config --global user.email "coverage-comment-action"
  git config --global user.name "Coverage Comment Action"
  git commit -m "stats"

  git push -u origin
else
  echo "No change detected, skipping."
fi
