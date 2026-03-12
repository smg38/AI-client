#!/usr/bin/env bash
# AI-client library
# Версия: 2.0.0
# Автор: TG: @smg38

GREEN="\033[1;32m"
BLUE="\033[1;34m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
GRAY="\033[0;37m"
RESET="\033[0m"

LOG_LEVEL="${LOG_LEVEL:-info}"

log() {
    local level="$1"
    shift
    local message="$*"

    # Skip if below current log level
    case "$LOG_LEVEL" in
        debug) ;;
        info)  [[ "$level" == "debug" ]] && return ;;
        warn)  [[ "$level" == "debug" || "$level" == "info" ]] && return ;;
        error) [[ "$level" != "error" ]] && return ;;
    esac

    # Colorize terminal output
    case "$level" in
        debug) color="${GRAY}" ;;
        info)  color="${BLUE}" ;;
        warn)  color="${YELLOW}" ;;
        error) color="${RED}" ;;
        *)     color="${RESET}" ;;
    esac

    # Terminal output with color (stderr)
    echo -e "${color}[$level] $message${RESET}" >&2
    # File log (plain text)
    echo "[$level] $message" >> "$LOGFILE"
}

aic_require() {
command -v "$1" >/dev/null || {
    log error "❌ missing $1"
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

#####################################
# logging
#####################################

aic_log(){

level="$1"
msg="$2"
types=(DEBUG INFO WARN ERROR CRI)  

ts=$(date "+%m-%d %H:%M:%S")

echo "[$ts] [$level] $msg" | tee "$LOGFILE"

}