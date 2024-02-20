#!/bin/bash
set -e
module purge && module load OESingleCell/2.0.0
## 默认变量
num=1000

# 显示帮助信息的函数
show_help() {
    echo "Usage: $0 "
    echo "Options:"
    echo "  -i rds"
    echo "  -s species hm:human;mm:mouse"
    # echo "  -o output default: ./"
    echo "  -n Parallel cell count"
    echo "  -g group vs,eg:'sampleid:A:B'"
    echo "  --help         Display this help message"
    exit 0
}
# 判断参数 是否为 help
need_help=$1

if [[ $need_help == "-h" || $need_help == "--help" ]] ; then
  show_help
  exit
fi
#########
while getopts ":i:s:n:o:g:" opt; do
  case $opt in
    i)
      rds="$OPTARG"
      ;;
    s)
      species="$OPTARG"
      ;;
    n)
      num="$OPTARG"
      ;;
    o)
      output="$OPTARG"
      ;;
    g)
      group="$OPTARG"
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
  esac
done

if [[ $species == 'mm' ]];then
  go_bp=/data/database/GSEA_gmt/mouse/v2023/m5.go.bp.v2023.1.Mm.symbols.gmt
  kegg=/data/database/GSEA_gmt/mouse/gene_kegg.gmt
elif [[ $species == "hm" ]];then
  go_bp=/data/database/GSEA_gmt/human/v2023/c5.go.bp.v2023.1.Hs.symbols.gmt
  kegg=/data/database/GSEA_gmt/human/v2023/c2.cp.kegg.v2023.1.Hs.symbols.gmt
else
  echo 'species error! only human mouse'
  exit
fi

# gsva 快速分析

Rscript /home/luyao/10X_scRNAseq_v3/src/Enrichment/GSVA_enrich.R \
-i $rds \
-f seurat   \
-g $go_bp  \
-o  ./GSVA_GO_BP  \
-c  $num  \
-k Poisson \
-a  FALSE  \
-s 2  \
-S 10000  \
-j 4 \
-x  TRUE &

Rscript /home/luyao/10X_scRNAseq_v3/src/Enrichment/GSVA_enrich.R \
-i $rds \
-f seurat   \
-g $kegg  \
-o  ./GSVA_KEGG  \
-c  $num  \
-k Poisson \
-a  FALSE  \
-s 2  \
-S 10000  \
-j 4 \
-x  TRUE &
wait
# 2
Rscript /home/luyao/10X_scRNAseq_v3/src/Enrichment/GSVA_pathway_diffxp.R  \
-i ./GSVA_GO_BP/GSVA_enrichment_results.xls \
-v $rds \
-c $group \
-p 0.05 \
-n 10 \
-d TRUE \
-o ./GSVA_GO_BP

Rscript /home/luyao/10X_scRNAseq_v3/src/Enrichment/GSVA_pathway_diffxp.R  \
-i ./GSVA_KEGG/GSVA_enrichment_results.xls \
-v $rds \
-c $group \
-p 0.05 \
-n 10 \
-d TRUE \
-o ./GSVA_KEGG