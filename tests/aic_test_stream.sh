#!/usr/bin/env bash
# streaming parser test

source "$(dirname "$0")/../aic_stream.sh"

echo "TEST stream parser"

INPUT='data: {"choices":[{"delta":{"content":"hello"}}]}'

echo "$INPUT" |
awk '
/content/{
print "OK"
}
'