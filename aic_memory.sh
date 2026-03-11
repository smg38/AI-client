#!/usr/bin/env bash
# AI-client memory
# Версия: 2.0.0
# Автор: TG: @smg38

DB="$HOME/ai-client/memory.db"
USER_NAME="${AI_USER:-$USER}"

aic_init_db(){

mkdir -p "$HOME/ai-client"

sqlite3 "$DB" <<EOF
CREATE TABLE IF NOT EXISTS messages(
id INTEGER PRIMARY KEY,
user TEXT,
role TEXT,
content TEXT,
ts DATETIME DEFAULT CURRENT_TIMESTAMP
);
EOF

}

aic_save_msg(){

local role="$1"
local text="$2"

sqlite3 "$DB" \
"INSERT INTO messages(user,role,content)
VALUES('$USER_NAME','$role','$text');"

}

aic_load_context(){

sqlite3 -json "$DB" \
"SELECT role,content
FROM messages
WHERE user='$USER_NAME'
ORDER BY id DESC
LIMIT 10;"
}