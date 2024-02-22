#!/bin/bash
set -e

#!/bin/bash
###
input_rds="filtered.h5seurat"
cell_types=("Endothelial_cells" "Fibroblasts" "Macrophages_Monocytes" "NK_cells" "Pericytes" "Schwann_cells" "Smooth_muscle_cells" "T_cells")
analysis_type="new_celltype"
treat=""
control=""
#anno="/data/database/cellranger-refdata/refdata-gex-mm10-2020-A/annotation/"   ##mouse
#anno="/data/database/cellranger-refdata/refdata-gex-GRCh38-2020-A/annotation/"   #human
#anno="/data/database/cellranger-refdata/refdata-mRatBN7/annotation/"  # rat
# Loop through cell types
for cell_type in "${cell_types[@]}"; do
echo "module load OESingleCell/3.0.d
Rscript  /public/scRNA_works/pipeline/oesinglecell3/exec/sctool    \\
-i $input_rds     \\
-f h5seurat     \\
-o ./$cell_type-Diffexp/$treat-vs-$control     \\
--assay RNA     \\
--dataslot data,counts     \\
-j 10  \\
--predicate \"$analysis_type %in% c(\'$cell_type\')\" \\
diffexp     \\
-c group:$treat:$control     \\
-k 1.5     \\
-p 0.05    \\
-e presto

Rscript  /public/scRNA_works/pipeline/oesinglecell3/exec/sctool  annotation \\
-g ./$cell_type-Diffexp/$treat-vs-$control/group_$treat-vs-$control-all_diffexp_genes.xls \\
--anno $anno/gene_annotation.xls

Rscript   /public/scRNA_works/pipeline/oesinglecell3/exec/sctool  annotation \\
-g ./$cell_type-Diffexp/$treat-vs-$control/group_$treat-vs-$control-diff-pval-0.05-FC-1.5.xls \\
--anno $anno/gene_annotation.xls




### diffexp_heatmap
Rscript  /public/scRNA_works/pipeline/oesinglecell3/exec/scVis \\
-i $input_rds  \\
-f h5seurat \\
-o ./$cell_type-Diffexp/$treat-vs-$control  \\
-t 10 \\
--assay RNA \\
--slot data,scale.data \\
--predicate \"$analysis_type %in% c(\'$cell_type\') & group %in% c(\'$treat\',\'$control\')\" \\
diff_heatmap \\
-d ./$cell_type-Diffexp/$treat-vs-$control/group_$treat-vs-$control-diff-pval-0.05-FC-1.5.xls \\
-n 20 \\
-g group \\
--group_colors customecol2 \\
--sample_ratio 0.8

rm ./$cell_type-Diffexp/$treat-vs-$control/group_$treat-vs-$control-all_diffexp_genes.xls ./$cell_type-Diffexp/$treat-vs-$control/group_$treat-vs-$control-diff-pval-0.05-FC-1.5.xls

perl /gpfs/oe-scrna/ziqingzhen/script/enrichment/enrich_go_kegg.pl -infile $cell_type-Diffexp/$treat-vs-$control/*-vs-*-diff-*.xls \\
-go_bg $anno/gene_go.backgroud.xls \\
-category /gpfs/oe-scrna/ziqingzhen/script/enrichment/category.xls \\
-kegg_bg $anno/gene_kegg.backgroud.xls \\
-outdir $cell_type-Diffexp/$treat-vs-$control/enrichment  \\
-shelldir $cell_type-Diffexp/$treat-vs-$control/enrichment_sh

" > $cell_type-$treat-vs-$control.diff.sh

done