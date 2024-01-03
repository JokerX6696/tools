#!/bin/bash
set -e
# 20240103已废弃！
# 自动化链接备份文件
# 标准化路径处理
# 20230516 脚本迭代： 更新内容为所有变量 添加 双引号，防止有文件包含空格！
path_pre="$1"
path=$(echo "$path_pre"|awk -F "/" '{print "/"$2"/"$3"/"$4}')

m=$(whoami)
# 备份 xlsx 文件
find "$path" -name "*xlsx"|grep -vE "QC.summary.xlsx|Capture-tools.xlsx|Mapping.summary.xlsx"|while read L
do
    if [ -L "$L" ]
    then
        continue
    fi

    NUM=$(echo $L|awk -F "/" '{print $5}')
    M=$(stat -c '%U' "$L")

    if [ "$M" != "$m" ]
    then
        echo -e "\e[31m Warning \033[0m:"$L" may not be your file!!!"
    fi

    lk="${L##*/}"
    NUM=$(echo "$L"|awk -F "/" '{print $5}')

    if [ -L "${path}/$NUM/Backup/$lk" ]
    then
        echo -e "\033[36m${path}/Basic/Backup/$lk\033[0m 已经存在，跳过！"
    elif [ -f "${path}/$NUM/Backup/$lk" ]
    then
        echo -e "\033[36m${path}/Basic/Backup/$lk\033[0m 已经存在，跳过！"
    else
        if [ -w "${path}/$NUM/Backup" ]
        then
            ln -s "$L" "${path}/$NUM/Backup/$lk"
            echo -e "已将 \033[36m$L\033[0m 链接至 \033[36m${path}/$NUM/Backup/$lk\033[0m"
        else
            echo -e "$(whoami)在 \033[36m${path}/$NUM/Backup\033[0m 没有写入权限！！！"
        fi
    fi
done

# 备份报告
find "$path" -name "*结题报告.zip"|grep -v "fastqc"|while read R
do
    if [ -L "$R" ]
    then
        continue
    fi
    lk="${R##*/}"
    NUM=$(echo "$R"|awk -F "/" '{print $5}')
    if [ -L "${path}/${NUM}/Backup/$lk" ]
    then
        echo -e "\033[36m${path}/Basic/Backup/$lk\033[0m 已经存在，跳过！"
    elif [ -f "${path}/${NUM}/Backup/$lk" ]
    then
        echo -e "\033[36m${path}/Basic/Backup/$lk\033[0m 已经存在，跳过！"
    else
        if [ -w "${path}/$NUM/Backup" ]
        then
            ln -s "$R" "${path}/$NUM/Backup/$lk"
            echo -e "已将 \033[36m$R\033[0m 链接至 \033[36m${path}/$NUM/Backup/$lk\033[0m"
        else
            echo -e "$(whoami) 在 \033[36m${path}/$NUM/Backup/\033[0m 没有写入权限！！！"
            echo -e "无法创建链接 ${path}/$NUM/Backup/$lk ！！！"
        fi
    fi
