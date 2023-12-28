#!/bin/bash -e
#samtools='/data/software/samtools/samtools-v1.3.1/bin/samtools'


bam2fq(){
    sample_pre=$1
    sample=$(echo $sample_pre|sed 's/.bam//g')
    if [ -d "$sample" ];then
        mkdir $sample
    fi
    /data/software/samtools/samtools-v1.3.1/bin/samtools fastq ${sample_pre} \
    -1 ${sample}_R1.fastq.gz -2 ${sample}_R2.fastq.gz \
    -0 /dev/null -s /dev/null -n
}

max_concurrent_tasks=10
counts=0
for i in *bam
do
    bam2fq $i &
    printf"$i 开始拆分 \n" 
    ((++counts))
    if [[ $counts -ge $max_concurrent_tasks ]];then
        sleep 1
        wait
        counts=0
    fi
done


