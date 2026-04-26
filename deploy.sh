#!/bin/bash

cd "$(dirname "$0")"

git add -A

if git diff --cached --quiet; then
  echo "変更なし。deployをスキップします。"
  exit 0
fi

read -p "コミットメッセージを入力してください: " msg
git commit -m "$msg"
git push

echo "✅ deployが完了しました。"
