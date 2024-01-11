#!/bin/bash
set -e
jsfile=$1
houzhui=$(echo $jsfile|awk -F "." '{print $NF}')
if [[ $houzhui == 'csv' ]];then
	fengefu=','
elif [[ $houzhui == 'tsv' ]];then
	fengefu='\t'
fi

paste -d "${fengefu}" \
<(cut -f1 -d "${fengefu}" ${jsfile}) \
<(cut -f2  ${jsfile} -d "${fengefu}"| \
sed 's/^\s\s*//g;s/\s\s*$//g;s/\s\s*/_/g;s/&/_/g;s/+/_/g;s/-/_/g'|sed 's/__*/_/g') > new_celltype_Standard.${houzhui}

