mv clusters_correlation visualize_cluster_by_clusters Clustering
cd Clustering/
rm -r sampleid-batchid.xls seurat.h5seurat pca_Dimension_Reduction
cd ..
rm -rf enrichment_sh/
rm -rf Marker/top50*
rm -rf Marker/all_markers_for_each_cluster.xls
rm -rf Marker/top10_markers_for_each_cluster.xls