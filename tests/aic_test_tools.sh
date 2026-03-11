#!/usr/bin/env bash

source "$(dirname "$0")/../aic_tools.sh"

echo "TEST tools"

OUT=$(aic_tool_disk_usage)

if [[ "$OUT" == *Filesystem* ]]
then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi

OUT=$(aic_tool_memory_usage)

if [[ "$OUT" == *Mem:* ]]
then
    echo "OK"
else
    echo "FAIL"
    exit 1
fi