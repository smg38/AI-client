#!/usr/bin/env bash
# AI-client library
# Версия: 2.0.0
# Автор: TG: @smg38

GREEN="\033[1;32m"
BLUE="\033[1;34m"
RED="\033[1;31m"
GRAY="\033[0;37m"
RESET="\033[0m"

aic_require() {
command -v "$1" >/dev/null || {
echo -e "${RED}❌ missing $1${RESET}"
exit 1
}
}

aic_usage() {

cat <<EOF
AI-client

usage:
aic_chat.sh "question"

pipe:
cat file | aic_chat.sh "analyze"

interactive:
aic_chat.sh -i
EOF
}