#!/bin/bash
set -e

ag=$1

if [[ $ag == 'sub' ]];then
	rm -rf featureplot_vlnplot/genes_not_matched.xls
	rm -rf ./*/Clustering/pca_Dimension_Reduction
	rm -rf ./*/Clustering/mnn_Dimension_Reduction
	rm -rf ./*/Clustering/sampleid-batchid.xls
	rm -rf ./*/Clustering/seurat.h5seurat
	rm -rf ./*/Marker/all_markers_for_each_cluster.xls
	rm -rf ./*/Marker/top10_markers_for_each_cluster.xls
fi

if [[ $ag == 'diff' ]];then
        rm -rf */*/enrichment_sh/
        rm -f cmd*
        rm -f Rplot*
        rm -f config.yaml
        find . -name "*" -type f -size 0c|xargs -n 1 rm -f
fi

