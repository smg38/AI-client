#!/usr/bin/env bash
# AI-client - система взаимодействия с ИИ
# Версия: 2.0.0
# Дата создания: 2026-03-11
# Автор: TG: @smg38
# Префикс: aic_

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$DIR/aic_lib.sh"
source "$DIR/aic_config.sh"
source "$DIR/aic_memory.sh"
source "$DIR/aic_stream.sh"
source "$DIR/aic_highlight.sh"

aic_require curl
aic_require jq
aic_require sqlite3

aic_init_config
aic_init_db

QUESTION="${*:-}"

if ! [ -t 0 ]; then
    QUESTION="$QUESTION
$(cat)"
fi

if [[ -z "$QUESTION" ]]; then
    aic_usage
    exit 0
fi

MODEL=$(aic_default_model)

log info "❓ $QUESTION"
log info "⏳ processing..."

CONTEXT=$(aic_load_context)

JSON=$(jq -n \
--arg model "$MODEL" \
--arg q "$QUESTION" \
--argjson ctx "$CONTEXT" '
{
model:$model,
messages: ($ctx + [{role:"user",content:$q}]),
stream:true
}')

ANSWER=$(aic_stream_request "$MODEL" "$JSON")

echo
log info "$ANSWER"
echo "$ANSWER" | aic_highlight

aic_save_msg user "$QUESTION"
aic_save_msg assistant "$ANSWER"