#!/usr/bin/env bash

source "$(dirname "$0")/..//aic_rag.sh"

echo "TEST rag"

mkdir -p testdocs
echo "Linux kernel" > testdocs/doc1.txt

aic_rag_index testdocs

RES=$(aic_rag_query "kernel")

if [[ "$RES" == *Linux* ]]
then
echo "OK"
else
echo "FAIL"
exit 1
fi