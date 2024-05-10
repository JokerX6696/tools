#!/bin/bash
# 取 marker gene top n
set -e


file=$1
top_n=$2
head -1 $file > genelist.txt
sed '1d' $file|cut -f7|sort -u|while read cluster
do
  awk -v cluster=$cluster -v top=$top_n 'BEGIN{counts=0;}{if($7==cluster){counts++;if(counts > top){exit};print$0}}' $file >> genelist.txt
done