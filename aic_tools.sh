#!/usr/bin/env bash
# AI-client - tools execution
# Версия: 2.2.0
# Дата создания: 2026-03-11
# Автор: TG: @smg38
# Префикс: aic_

#####################################
# доступные tools
#####################################

aic_tool_disk_usage(){

df -h
}

aic_tool_memory_usage(){

free -h
}

aic_tool_list_processes(){

ps aux --sort=-%mem | head -n 10
}

#####################################
# router tool
#####################################

aic_tool_run(){

tool="$1"

case "$tool" in

disk_usage)
aic_tool_disk_usage
;;

memory_usage)
aic_tool_memory_usage
;;

processes)
aic_tool_list_processes
;;

*)
echo "Unknown tool: $tool"
return 1
;;

esac

}