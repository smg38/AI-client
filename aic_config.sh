#!/usr/bin/env bash
# AI-client config
# Версия: 2.0.0
# Автор: TG: @smg38

CONFIG="./.config.yaml"
FALLBACK="$HOME/ai-client/.config.yaml"

LOGFILE="/var/log/ai-client/chat.log"

aic_init_config(){

if [[ -f "$CONFIG" ]]; then
CFG="$CONFIG"

elif [[ -f "$FALLBACK" ]]; then
CFG="$FALLBACK"

else
mkdir -p "$HOME/ai-client"

cat > "$FALLBACK" <<EOF
providers:

  routerai:
    base_url: https://routerai.ru/api/v1
    api_key: CHANGE_ME

models:

  fast:
    provider: routerai
    model: qwen/qwen3-vl-30b-a3b-thinking
    default: true
EOF

CFG="$FALLBACK"

fi

mkdir -p /var/log/ai-client 2>/dev/null || true
LOG_LEVEL="${LOG_LEVEL:-info}"
touch "$LOGFILE" 2>/dev/null || LOGFILE="$HOME/ai-client/chat.log"

}

aic_default_model(){

yq '.models[] | select(.default==true) | .model' "$CFG"
}