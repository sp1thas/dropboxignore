#!/usr/bin/env bash

set -eux

dir="$(mktemp -d)"
cd "$dir"

git clone "https://x-access-token:${0}@github.com/sp1thas/dropboxignore.wiki.git" .

total_downloads=$(curl -s https://api.countapi.xyz/info/dropboxignore.simakis.me/total | jq -r .value)

JSON_STRING=$(cat <<-END
{"schemaVersion": 1, "label": "installations", "message": "${title}", "body": $(curl -s https://api.countapi.xyz/info/dropboxignore.simakis.me/total | jq -r .value), "color": "blue"}
END
)


echo "$JSON_STRING" > stats.json

git add stats.json

if ! git diff --staged --exit-code
then
    git config --global user.email "coverage-comment-action"
    git config --global user.name "Coverage Comment Action"
    git commit -m "stats"

    git push -u origin
else
    echo "No change detected, skipping."
fi