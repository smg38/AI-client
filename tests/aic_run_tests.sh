#!/usr/bin/env bash
# AI-client tests runner

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"

echo "AI-client test suite"

for t in "$DIR"/aic_test_*.sh
do
echo "running $t"
bash "$t"
done

echo "ALL TESTS PASSED"        