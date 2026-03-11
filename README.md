# AI-client
Система взаимодействия с ИИ из терминала

Версия: 2.2.0  
Дата создания: 2026-03-11  
Автор: TG @smg38  
Префикс: aic_

---

# Возможности

AI-client — универсальный CLI для работы с AI API.

Поддерживает:

✔ RouterAI  
✔ Google Gemini  
✔ Streaming ответы  
✔ SQLite память диалога  
✔ Pipe режим  
✔ Интерактивный режим  
✔ Tool calling  
✔ Локальный RAG  
✔ Автономный AI-агент  
✔ ANSI подсветку кода  
✔ YAML конфигурацию  
✔ Unit tests  

---

# Структура проекта
```
ai-client
│
├── aic_chat.sh
├── aic_config.sh
├── aic_stream.sh
├── aic_memory.sh
├── aic_highlight.sh
├── aic_tools.sh
├── aic_rag.sh
├── aic_agent.sh
├── aic_cost.sh
│
├── tests
│   ├── aic_test_stream.sh
│   ├── aic_test_memory.sh
│   ├── aic_test_rag.sh
│   ├── aic_test_tools.sh
│   ├── aic_test_cost.sh
│   └── aic_run_tests.sh
│
└── aic_README.md
```

---

# Установка

`apt install curl jq sqlite3 yq awk`


---

# Файлы:
### Конфигурация
~/.config.yaml
### Лог:
~/ai-client/chat.log
### База данных памяти:
~/ai-client/memory.db
### База докуументов:
~/ai-client/rag.db

## пример конфигурации:

```yaml
providers:

  routerai:
    base_url: https://routerai.ru/api/v1
    api_key: ROUTER_KEY

  gemini:
    api_key: GEMINI_KEY

models:

  fast:
    provider: routerai
    model: qwen/qwen3-vl-30b-a3b-thinking
    default: true

  gemini_flash:
    provider: gemini
    model: gemini-3-flash-preview
```

# Основные команды
###  простой запрос

`aic_chat.sh "Explain Linux"`

### выбор модели
`aic_chat.sh -m gemini_flash "Explain AI"`

### pipe режим

`cat log.txt | aic_chat.sh "Find errors"`

### интерактивный режим

`aic_chat.sh -i`


# Использование мониторинга
## Показать статистику пользователя
`aic_cost_user "$USER"`

пример вывода

12000 | 48000 | 0.37

(токены prompt | completion | стоимость)

## Cтатистика по моделям
aic_cost_models

пример

qwen/qwen3-vl-30b   0.23
gemini-flash        0.14
Использование внутри клиента

после получения ответа API:

aic_cost_record \
"$USER" \
"$MODEL" \
"$PROMPT_TOKENS" \
"$COMP_TOKENS"
## 👤 пользовательская команда

можно добавить CLI:

`aic_chat.sh --cost`

вывод:

User usage

prompt tokens: 12345
completion tokens: 65432
total cost: $0.42
===

# Для разработчиков.
## Документация функций

## `aic_stream_routerai`

Streaming ответ RouterAI.

### параметры

`aic_stream_routerai MODEL JSON`

пример

`MODEL="fast"`
```json
JSON='{
"model":"qwen/qwen3",
"messages":[
{"role":"user","content":"hello"}
],
"stream":true
}'
```
`aic_stream_routerai "$MODEL" "$JSON"`

## `aic_stream_gemini`

Streaming для Gemini.

параметры

`aic_stream_gemini PROMPT`

пример

`aic_stream_gemini "Explain AI"`

## `aic_save_msg`

Сохраняет сообщение в SQLite.

`aic_save_msg ROLE TEXT`

пример

`aic_save_msg user "hello"`

## `aic_load_context`

Загружает последние сообщения диалога.

`aic_load_context`

## Tool Calling

ИИ может запускать системные команды.

файл:  
aic_tools.sh

пример tools:
```bash
disk_usage
memory_usage
list_processes
```

пример:

`aic_chat.sh "show disk usage"`

ИИ выполнит

`df -h`

## Локальный RAG

ИИ может использовать локальные документы.

индексирование

`aic_rag_index docs/`

создаётся база:

`~/ai-client/rag.db`

запрос

`aic_rag_query "Explain Kubernetes"`

RAG добавляет найденные документы в prompt.

## Автономный AI-агент

ИИ может выполнять задачи.

пример:

`aic_chat.sh "install nginx and configure reverse proxy"`

агент:

1 анализирует задачу
2 планирует шаги
3 выполняет команды

Пример агента

`aic_agent_run "check disk usage"`

## Подсветка кода

ANSI highlighting.

aic_highlight

пример

`echo "$CODE" | aic_highlight`

## Логирование

/var/log/ai-client/chat.log


## fallback

~/ai-client/chat.log

## Unit tests

Все функции покрыты тестами.

папка `tests/`

### Запуск всех тестов
```bash
cd tests
./aic_run_tests.sh
```
вывод:

AI-client test suite
running aic_test_stream.sh
OK
running aic_test_memory.sh
OK
running aic_test_rag.sh
OK
running aic_test_tools.sh
OK
running aic_test_cost.sh
OK

ALL TESTS PASSED

## Мульти-пользовательская память

AI_USER=telegram aic_chat.sh "hello"

## Производительность
cmd|режим|скорость
----|---|---
jq |streaming|	3-5 KB/s
awk |streaming|	80-100 KB/s