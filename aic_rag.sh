#!/usr/bin/env bash
# AI-client - local RAG
# Версия: 2.2.0
# Дата создания: 2026-03-11
# Автор: TG: @smg38
# Префикс: aic_

AIC_RAG_DB="$HOME/ai-client/rag.db"

####################################
# init rag database
####################################

aic_rag_init(){

mkdir -p "$HOME/ai-client"

sqlite3 "$AIC_RAG_DB" <<EOF
CREATE TABLE IF NOT EXISTS docs(
id INTEGER PRIMARY KEY,
path TEXT,
content TEXT
);
EOF

}

####################################
# index folder
####################################

aic_rag_index(){

dir="$1"

aic_rag_init

find "$dir" -type f | while read file
do

text=$(head -c 20000 "$file")

sqlite3 "$AIC_RAG_DB" \
"INSERT INTO docs(path,content)
VALUES('$file','$(printf "%q" "$text")');"

done

}

####################################
# search
####################################

aic_rag_query(){

query="$1"

sqlite3 "$AIC_RAG_DB" \
"SELECT content FROM docs
WHERE content LIKE '%$query%'
LIMIT 3;"
}