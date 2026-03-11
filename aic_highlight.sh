#!/usr/bin/env bash
# AI-client highlight
# Версия: 2.0.0
# Автор: TG: @smg38

aic_highlight(){

while IFS= read -r line
do

if [[ "$line" =~ ^\`\`\` ]]; then
echo -e "\033[1;33m$line\033[0m"
continue
fi

if [[ "$line" =~ ^[[:space:]]*(if|for|while|function|def|class|return) ]]; then
echo -e "\033[1;36m$line\033[0m"
continue
fi

echo "$line"

done

}