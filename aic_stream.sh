#!/usr/bin/env bash
# AI-client streaming
# Версия: 2.1.0
# Автор: TG: @smg38

########################################
# aic_stream_routerai
#
# streaming для RouterAI/OpenAI API
#
# параметры:
# $1 model
# $2 json_body
########################################

aic_stream_routerai() {

local MODEL="$1"
local JSON="$2"

BASE_URL=$(yq '.providers.routerai.base_url' "$CFG")
API_KEY=$(yq '.providers.routerai.api_key' "$CFG")

curl -sN \
-H "Authorization: Bearer $API_KEY" \
-H "Content-Type: application/json" \
-d "$JSON" \
"$BASE_URL/chat/completions" |

awk '

/^data:/ {

gsub(/^data: /,"")

if($0=="[DONE]") exit

match($0,/"content":"([^"]*)"/,a)

if(a[1]!="") {

gsub(/\\n/,"\n",a[1])
gsub(/\\"/,"\"",a[1])

printf "%s",a[1]
fflush()

}

}
'
}

########################################
# aic_stream_gemini
#
# streaming Gemini API
#
# параметры:
# $1 prompt
########################################

aic_stream_gemini(){

local PROMPT="$1"

API_KEY=$(yq '.providers.gemini.api_key' "$CFG")

curl -s \
"https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent" \
-H "x-goog-api-key: $API_KEY" \
-H 'Content-Type: application/json' \
-X POST \
-d "{
\"contents\":[
{
\"parts\":[
{\"text\":\"$PROMPT\"}
]
}
]
}" |

awk '

/"text":/ {

match($0,/"text": *"([^"]+)"/,a)

if(a[1]!="") {

gsub(/\\n/,"\n",a[1])
gsub(/\\"/,"\"",a[1])

print a[1]

}

}
'
}

########################################
# универсальный router
########################################

aic_stream_request(){

local MODEL="$1"
local JSON="$2"

PROVIDER=$(yq ".models.$MODEL.provider" "$CFG")

case "$PROVIDER" in

routerai)
aic_stream_routerai "$MODEL" "$JSON"
;;

gemini)
PROMPT=$(echo "$JSON" | jq -r '.messages[-1].content')
aic_stream_gemini "$PROMPT"
;;

*)
echo "Unknown provider $PROVIDER"
exit 1
;;

esac

}