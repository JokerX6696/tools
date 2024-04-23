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
sed 's|/|_|g;s/^\s\s*//g;s/\s\s*$//g;s/\s\s*/_/g;s/&/_/g;s/+/_/g;s/-/_/g'|sed 's/__*/_/g') > new_celltype_Standard.${houzhui}

# def strQ2B(ustring):
#     """全角转半角"""
#     rstring = ""
#     for uchar in ustring:
#         inside_code = ord(uchar)
#         print(inside_code)
#         if inside_code == 12288:  # 全角空格直接转换
#             inside_code = 32
#         elif 65281 <= inside_code <= 65374:  # 全角字符（除空格）根据关系转化
#             inside_code -= 65248
 
#         rstring += unichr(inside_code)
#     return rstring
 
 
# def strB2Q(ustring):
#     """半角转全角"""
#     rstring = ""
#     for uchar in ustring:
#         inside_code = ord(uchar)
#         if inside_code == 32:  # 半角空格直接转化
#             inside_code = 12288
#         elif 32 <= inside_code <= 126:  # 半角字符（除空格）根据关系转化
#             inside_code += 65248
 
#         rstring += unichr(inside_code)
#     return rstring