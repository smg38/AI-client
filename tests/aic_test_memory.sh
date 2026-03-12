#!/bin/bash
# Определяем текущий каталог теста
TEST_DIR=$(dirname "$0")
# Исправленное подключение основного скрипта
source "$TEST_DIR/../aic_memory.sh" || { echo "ERROR: Unable to load aic_memory.sh"; exit 1; }

echo "TEST memory"
# Создаем директорию для тестовой БД
mkdir -p /tmp/ai-client
export AI_CLIENT_DIR=/tmp/ai-client

aic_init_db
aic_save_msg "user" "test message"
RES=$(aic_load_context)
if [[ "$RES" == *"test message"* ]]; then
  echo "Save PASS"
  RES=$(aic_del_msg "user" "test message")
  if [[ ! "$RES" ]]; then
    echo "Delete PASS"
  else
    echo "Delete FAIL"
    exit 1
  fi
else
  echo "FAIL"
  exit 1
fi
