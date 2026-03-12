#!/usr/bin/env bash
# AI-client config
# Версия: 2.1.0
# Автор: TG: @smg38

CONFIG="./.config.yaml"
FALLBACK="./.config_example.yaml"   #"$HOME/ai-client/.config.yaml"
LOGFILE="./aic_chat.log"
LOG_LEVEL="${LOG_LEVEL:-info}"
#LOGFILE="/var/log/ai-client/chat.log"

aic_init_config(){

if [[ -f "$CONFIG" ]]; then
CFG="$CONFIG"

elif [[ -f "$FALLBACK" ]]; then
CFG="$FALLBACK"

# else
# mkdir -p "$HOME/ai-client"

cat > "$FALLBACK" <<EOF
providers:

  routerai:
    base_url: https://routerai.ru/api/v1s
    api_key: CHANGE_ME

models:

  fast:
    provider: routerai
    model: qwen/qwen3-vl-30b-a3b-thinking
    default: true
EOF

CFG="$FALLBACK"

fi

#mkdir -p /var/log/ai-client 2>/dev/null || true
#touch "$LOGFILE" 2>/dev/null || LOGFILE="$HOME/ai-client/chat.log"
log info "Config: $CFG LogLevel: $LOG_LEVEL"

}

aic_default_model(){

yq '.models[] | select(.default==true) | .model' "$CFG"
}