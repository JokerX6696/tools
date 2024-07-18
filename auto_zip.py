#!/data/software/miniconda/envs/snakemake/bin/python
import argparse
import requests
import os
import re
from datetime import datetime


# 解析命令行参数
parser = argparse.ArgumentParser(description="Send a PUT request with project ID.")
parser.add_argument('--pjpath', required=True, help='The project ID')
args = parser.parse_args()
# 解析 项目号
pjpath = args.pjpath
path_info = pjpath.split('/')
if path_info[3] != 'further_analysis':
    exit('请手动操作！')
pjid = path_info[6]
pjid = re.sub("-b.+","",pjid)
# 设置目标URL
url = "*****************************************"

# 设置请求头
headers = {'Content-Type': 'application/json'}

# 设置请求数据
data = {"project_id": f"{pjid}-b1"}

# 发送PUT请求
response = requests.put(url, headers=headers, json=data)

# 判断是否成功
if response.status_code != 200:
    exit(f'请求失败 状态码为 {response.status_code} !')
# 操作返回数据
info = response.json()
name1 = info['客户姓名']
name2 = info['联系人姓名']
# get time
now = datetime.now()
formatted_date = now.strftime("%Y%m%d")
if name1 == name2:
    ret_name = pjid + "_" + name1 + "_" + formatted_date
else:
    ret_name = pjid + "_" + name1 + "_" + name2 + "_" + formatted_date
# 创建目录
if not os.path.exists(ret_name):
    os.makedirs(ret_name)
    print(f"Directory '{ret_name}' created successfully")
else:
    print(f"Directory '{ret_name}' already exists")

# 后续基于自动化工作流 完成自动化打包