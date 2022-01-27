#!/usr/bin/env bash

set -eux

stdin="$(cat -)"
dir="$(mktemp -d)"
cd $dir

git clone "https://x-access-token:${GITHUB_TOKEN}@github.com/sp1thas/dropboxignore.wiki.git" .

total_downloads=$(curl -s https://api.countapi.xyz/info/dropboxignore.simakis.me/total | jq -r .value)

JSON_STRING=$(jq -n \
                  --arg schemaVersion 1 \
                  --arg label "installations" \
                  --arg message "$total_downloads" \
                  --arg color "blue" \
                   '$ARGS.named')

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