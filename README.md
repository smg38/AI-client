# AI-client

Система взаимодействия с ИИ из терминала.

Версия: 2.0.0

Автор: TG @smg38

---

# Возможности

- streaming ответы
- sqlite память
- интерактивный режим
- pipe режим
- fallback моделей
- yaml конфиг
- ansi подсветка

---

# Установка

`apt install curl jq sqlite3 yq`

# Запуск
`chmod +x aic_chat.sh`
`./aic_chat.sh "hello"`

# pipe режим
`cat log.txt | ./aic_chat.sh "analyze errors"`

# Интерактивный режим
`./aic_chat.sh -i`

# Мульти-пользовательская память
`AI_USER=telegram ./aic_chat.sh "hello"`

# Конфигурация
`~/.ai-client/.config.yaml`

# Пример:
```
providers:

  routerai:
    base_url: https://routerai.ru/api/v1
    api_key: KEY

models:

  fast:
    provider: routerai
    model: qwen/qwen3-vl-30b-a3b-thinking
    default: true
```
# Лог
/var/log/ai-client/chat.log

# База памяти
~/ai-client/memory.db