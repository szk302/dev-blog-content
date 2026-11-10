#!/usr/bin/env bash
# 使い方: ./sa-keys-report.sh PROJECT_ID... > report.html
set -euo pipefail

# この日数以上経過したキーを「要確認」にする
warn_days=${WARN_DAYS:-90}

if [ "$#" -eq 0 ]; then
  echo "usage: $0 PROJECT_ID..." >&2
  exit 2
fi

records=$(mktemp)
trap 'rm -f "$records"' EXIT

# ユーザー管理のキーを1件1行のJSONにして溜める
for project in "$@"; do
  accounts=$(gcloud iam service-accounts list --project "$project" --format 'value(email)')
  for account in $accounts; do
    gcloud iam service-accounts keys list --iam-account "$account" --managed-by user --format json |
      jq -c --arg project "$project" --arg account "$account" \
        '.[] + {project: $project, account: $account}' >>"$records"
  done
done

# 表示する項目に変換し、古い順に並べる
keys=$(jq -s --argjson warn_days "$warn_days" '
  now as $now
  | map(
      (($now - (.validAfterTime | sub("\\.[0-9]+Z$"; "Z") | fromdate)) / 86400 | floor) as $age
      | {
          project,
          account,
          id: (.name | split("/") | last),
          created: .validAfterTime[:10],
          age: $age,
          expires: (if (.validBeforeTime | startswith("9999")) then "なし" else .validBeforeTime[:10] end),
          status: (
            if .disabled then "無効"
            elif .validBeforeTime < ($now | todate) then "期限切れ"
            elif $age >= $warn_days then "要確認"
            else "正常"
            end
          )
        }
    )
  | sort_by(-.age)
' "$records")

count() { jq --arg status "$1" 'map(select(.status == $status)) | length' <<<"$keys"; }
targets=$(jq -nr '$ARGS.positional | join(", ") | @html' --args "$@")

cat <<EOF
<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8">
<title>サービスアカウントキー一覧</title>
<style>
  body { font-family: system-ui, sans-serif; margin: 2rem; color: #222; }
  h1 { font-size: 1.4rem; }
  table { border-collapse: collapse; font-size: .9rem; }
  th, td { border: 1px solid #ccc; padding: .4rem .6rem; text-align: left; white-space: nowrap; }
  th { background: #f0f0f0; }
  td:nth-child(5) { text-align: right; }
  tr[data-status="要確認"] { background: #fff4cc; }
  tr[data-status="期限切れ"] { background: #ffd9d6; }
  tr[data-status="無効"] { color: #888; }
</style>
</head>
<body>
<h1>サービスアカウントキー一覧</h1>
<p>出力日時: $(date '+%Y-%m-%d %H:%M %Z')<br>対象: $targets</p>
<p>全 $(jq length <<<"$keys") 件 / 要確認 $(count 要確認) 件 / 期限切れ $(count 期限切れ) 件 / 無効 $(count 無効) 件 / 正常 $(count 正常) 件</p>
<table>
<thead>
<tr><th>プロジェクト</th><th>サービスアカウント</th><th>キーID</th><th>作成日</th><th>経過日数</th><th>有効期限</th><th>状態</th></tr>
</thead>
<tbody>
EOF

jq -r '.[] | @html "<tr data-status=\"\(.status)\"><td>\(.project)</td><td>\(.account)</td><td>\(.id)</td><td>\(.created)</td><td>\(.age)</td><td>\(.expires)</td><td>\(.status)</td></tr>"' <<<"$keys"

cat <<EOF
</tbody>
</table>
</body>
</html>
EOF
