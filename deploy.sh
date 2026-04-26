#!/bin/bash

cd "$(dirname "$0")"

git add -A

if git diff --cached --quiet; then
  echo "変更なし。deployをスキップします。"
  exit 0
fi

git commit -m "update: $(date '+%Y-%m-%d %H:%M')"
git push

echo "✅ deployが完了しました。"
