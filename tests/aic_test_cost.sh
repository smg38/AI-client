#!/bin/bash
TEST_DIR=$(dirname "$0")
source "$TEST_DIR/../aic_cost.sh" || { echo "ERROR: Unable to load aic_cost.sh"; exit 1; }

echo "TEST cost"
rm -f /tmp/ai-client/cost.db
mkdir -p /tmp/ai-client
export AIC_COST_DB="/tmp/ai-client/cost.db"
aic_cost_init
aic_cost_record "testuser" "gpt-3.5" 100 200
COST=$(aic_cost_user "testuser" | awk -F'|' '{print $3}' | tr -d '[:space:]')
EXPECTED="0.0005"
DIFF=$(awk "BEGIN{print ($COST-$EXPECTED)}")
if [[ $(echo "$DIFF < 0.00001 && $DIFF > -0.00001" | bc) -eq 1 ]]; then
    echo "PASS"
else
    echo "FAIL"
    echo "expected $EXPECTED got $COST"
    exit 1
fi
