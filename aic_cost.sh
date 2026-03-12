#!/usr/bin/env bash
# AI-client - token & cost monitor
# Версия: 2.2.0
# Автор: TG: @smg38
# Префикс: aic_

AIC_COST_DB="${AIC_COST_DB:-./aic.db}"

aic_cost_init(){
mkdir -p "$(dirname "$AIC_COST_DB")"
sqlite3 "$AIC_COST_DB" <<EOF
CREATE TABLE IF NOT EXISTS usage(
id INTEGER PRIMARY KEY,
user TEXT,
model TEXT,
prompt_tokens INTEGER,
completion_tokens INTEGER,
cost REAL,
ts DATETIME DEFAULT CURRENT_TIMESTAMP
);
EOF

}

###################################
# model pricing
###################################

aic_cost_price(){

model="$1"

case "$model" in

qwen*)
PROMPT=0.0005
COMP=0.0015
;;

gemini*)
PROMPT=0.00035
COMP=0.0010
;;

*)
PROMPT=0.001
COMP=0.002
;;

esac

}

###################################
# save usage
###################################

aic_cost_record(){

user="$1"
model="$2"
prompt_tokens="$3"
completion_tokens="$4"

aic_cost_price "$model"

cost=$(awk "BEGIN{
print ($prompt_tokens*$PROMPT/1000)+($completion_tokens*$COMP/1000)
}")

sqlite3 "$AIC_COST_DB" \
"INSERT INTO usage(user,model,prompt_tokens,completion_tokens,cost)
VALUES('$user','$model',$prompt_tokens,$completion_tokens,$cost);"

}

###################################
# user statistics
###################################

aic_cost_user(){

user="$1"

sqlite3 "$AIC_COST_DB" "
SELECT
SUM(prompt_tokens),
SUM(completion_tokens),
SUM(cost)
FROM usage
WHERE user='$user';
"

}

###################################
# top models
###################################

aic_cost_models(){

sqlite3 "$AIC_COST_DB" "
SELECT model,
SUM(cost)
FROM usage
GROUP BY model
ORDER BY SUM(cost) DESC;
"

}