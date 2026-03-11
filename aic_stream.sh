#!/usr/bin/env bash
# AI-client streaming
# Версия: 2.0.0
# Автор: TG: @smg38

aic_stream_request(){

MODEL="$1"
JSON="$2"

BASE_URL=$(yq '.providers.routerai.base_url' "$CFG")
API_KEY=$(yq '.providers.routerai.api_key' "$CFG")

OUT=""

curl -sN \
-H "Authorization: Bearer $API_KEY" \
-H "Content-Type: application/json" \
-d "$JSON" \
"$BASE_URL/chat/completions" |
while IFS= read -r line
do

[[ "$line" != data:* ]] && continue

chunk=${line#data: }

[[ "$chunk" == "[DONE]" ]] && break

text=$(printf "%s" "$chunk" |
jq -r '.choices[0].delta.content // empty')

printf "%s" "$text"
OUT+="$text"

done

echo "$OUT"
}