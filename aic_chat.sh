#!/usr/bin/env bash
# AI-client - система взаимодействия с ИИ
# Версия: 2.0.0
# Дата создания: 2026-03-11
# Автор: TG: @smg38
# Префикс: aic_

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_LEVEL=debug

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

log info "❓ Model: $MODEL Quest: $QUESTION"
CONTEXT=$(aic_load_context)
log info "⏳ Context was load. Processing..."
log debug "⏳ Context=$CONTEXT"
[ -z "$CONTEXT" ] && CONTEXT='[]'
arg_con="--argjson ctx $CONTEXT"
JSON=$(jq -n \
--arg model "$MODEL" \
--arg q "$QUESTION" \
$arg_con '
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
