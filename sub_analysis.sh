#!/bin/bash
set -e

### para_pre
version=3
reduct=pca
resolution=0.4
lieming='new_celltype'
seurat=false
species=false
cell=false
output='./'
### para

# 显示帮助信息的函数
show_help() {
    echo "Usage: $0 "
    echo "Options:"
    echo "  -i seurat.h5seurat"
    echo "  -s species hm:human;mm:mouse"
    # echo "  -o output default: ./"
    echo "  -c use cell to subclusting"
    echo "  -v wkdir env 2 or 3"
    echo "  -r reduct methods pca or mnn"
    echo "  -f resolution default:0.4"
    echo "  -l colname default:new_celltype"
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
while getopts ":i:s:o:c:v:r:f:l:" opt; do
  case $opt in
    i)
      seurat="$OPTARG"
      ;;
    s)
      species="$OPTARG"
      ;;
    o)
      output="$OPTARG"
      ;;
    c)
      cell="$OPTARG"
      ;;
    v)
      version="$OPTARG"
      ;;
    r)
      reduct="$OPTARG"
      ;;    
    f)
      resolution="$OPTARG"
      ;;   
    l)
      lieming="$OPTARG"
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
###########################################################################################
if [[ $seurat == 'false' || $species == 'false' || $cell == 'false' ]];then
  echo "-i -s -c 为必须参数！ 请填写"
  exit
else
  echo -e "采用 $reduct 降维 \n细胞分辨率resolution=$resolution \n可视化列名为 $lieming"
fi
#anno
if [[ $species == 'mm' ]];then
  anno=/data/database/cellranger-refdata/refdata-gex-mm10-2020-A/annotation/gene_annotation.xls
  specie=human
elif [[ $species == "hm" ]];then
  anno=/data/database/cellranger-refdata/refdata-gex-GRCh38-2020-A/annotation/gene_annotation.xls
  specie=Mouse
else
  echo 'species error! only human mouse'
  exit
fi



####  env
if [[ $version == 3 ]];then
  module purge && module load OESingleCell/3.0.d
elif [[ $version == 2 ]];then
  module purge && module load OESingleCell/2.0.0
else
  echo "work env error !!!"
  exit
fi
###########################    analysis ##################################################
if [[ $reduct == 'pca' ]];then
  Rscript  /public/scRNA_works/pipeline/oesinglecell3/exec/sctool  \
  -i  $seurat  \
  -f h5seurat  \
  -o sub_$cell/Clustering  \
  -d h5seurat   \
  --assay RNA  \
  --dataslot counts,data,scale.data   \
  --update F   \
  --predicate  "$lieming %in% c(\'${cell}\')"   \
  bclust   \
  --reduct1 pca  \
  --reduct2 umap   \
  --clusteringuse snn  \
  --resolution $resolution   \
  --rerun T   \
  --pointsize  0.5  \
  --palette customecol2
elif [[ $reduct == 'mnn' ]];then
  Rscript  /public/scRNA_works/pipeline/oesinglecell3/exec/sctool  \
  -i  $seurat  \
  -f h5seurat  \
  -o sub_$cell/Clustering  \
  -d h5seurat   \
  --assay RNA  \
  --dataslot counts,data,scale.data   \
  --update F   \
  --predicate  "$lieming %in% c(\'$cell\')"   \
  bclust   \
  --reduct1 mnn \
  --batchid batchid \
  --components 10  \
  --reduct2 umap \
  --clusteringuse snn  \
  --resolution $resolution   \
  --rerun T   \
  --pointsize  0.5   \
  --palette customecol2
else
  echo "reduct type error"
  exit
fi
seurat_sub="sub_$cell/Clustering/seurat.h5seurat"
Rscript /public/scRNA_works/pipeline/oesinglecell3/exec/sctool \
  -i  ${seurat_sub} \
  -f h5seurat \
  -o sub_$cell/Clustering \
  --assay RNA \
  --dataslot data \
  summarize \
  --reduct umap \
  --palette customecol2 \
  -c clusters \
  -b sampleid,group \
  --pointsize 0.5 \
  --dosummary T


Rscript /public/scRNA_works/pipeline/oesinglecell3/exec/scVis \
  -i ${seurat_sub}  \
  -f h5seurat \
  -o sub_${cell}/Clustering/clusters_correlation \
  -t 6 \
  --assay RNA \
  --slot data \
  --reduct umap \
  coefficient \
  -g clusters

Rscript /public/scRNA_works/pipeline/oesinglecell3/exec/sctool \
  -i ${seurat_sub}  \
  -f h5seurat \
  -o sub_${cell}/Marker \
  --assay RNA \
  --dataslot data,counts \
  -j 10 \
  findallmarkers \
  -c 2 \
  -N 10 \
  -k 1 \
  -p 0.05 \
  -s F \
  -e presto \
  -n clusters


#2.可视化+anno
# marker热图
Rscript /public/scRNA_works/pipeline/oesinglecell3/exec/scVis \
  -i ${seurat_sub}  \
  -f h5seurat \
  -o sub_${cell}/ \
  -t 10 \
  --assay RNA \
  --slot data,scale.data \
  heatmap \
  -l sub_$cell/Marker/top10_markers_for_each_cluster.xls \
  -c gene_diff \
  -n 10 \
  -g clusters \
  --group_colors customecol2 \
  --sample_ratio 0.8 \
  --style seurat

Rscript /public/scRNA_works/pipeline/oesinglecell3/exec/sctool \
  -i ${seurat_sub}   \
  -f h5seurat \
  -o sub_${cell}/ \
  -j 10 \
  --assay RNA \
  --dataslot data \
  visualize \
  -l sub_$cell/Marker/top10_markers_for_each_cluster.xls \
  -g clusters \
  --reduct umap \
  --topn  10  \
  --topby gene_diff \
  -m vlnplot,featureplot \
  --vcolors customecol2 \
  --ccolors spectral \
  --pointsize 0.3 \
  --dodge F
 

Rscript /public/scRNA_works/pipeline/oesinglecell3/exec/sctool annotation \
  -g sub_${cell}/Marker/all_markers_for_each_cluster.xls \
  --anno $anno  # 根据物种修改
Rscript  /public/scRNA_works/pipeline/oesinglecell3/exec/sctool annotation \
  -g sub_${cell}/Marker/top10_markers_for_each_cluster.xls \
  --anno $anno  # 根据物种修改

Rscript  /public/scRNA_works/pipeline/oesinglecell3/exec/sctool  \
-i ${seurat_sub}  \
-f h5seurat \
-o sub_${cell}/Reference_celltype \
-d h5seurat \
--update T \
--assay RNA \
--dataslot counts \
celltyping \
-r /data/database/celltype_refdata/logNorm_rds/immgen.rds \
--annolevel single \
--usecluster F \
--demethod classic \
--pointsize 0.3 \
-n 25 \
--reduct umap \
--species $specie
