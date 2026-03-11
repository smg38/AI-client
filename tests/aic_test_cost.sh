#!/bin/bash
# Определяем текущий каталог теста
TEST_DIR=$(dirname "$0")
# Исправленное подключение основного скрипта
source "$TEST_DIR/../aic_cost.sh" || { echo "ERROR: Unable to load aic_cost.sh"; exit 1; }

echo "TEST cost"
# Создаем директорию для тестовой БД
mkdir -p /tmp/ai-client
export AIC_COST_DB="/tmp/ai-client/cost.db"
mkdir -p "$(dirname "$AIC_COST_DB")"
echo "RUN aic_cost_init"
aic_cost_init
echo "RUN aic_cost_record"
aic_cost_record "testuser" "gpt-3.5" 100 200
echo "RUN aic_cost_record 2"
COST=$(aic_cost_user "testuser" | awk -F'|' '{print $3}' | tr -d '[:space:]')
if [[ $(echo "$COST == 0.0005" | bc) -eq 1 ]]; then
  echo "PASS"
else
  echo "FAIL"
  exit 1
fi
