#!/bin/bash

module use $HOME/modulefiles
module load plink
module load samtools
module load tabix
module load eagle

chr=${SLURM_ARRAY_TASK_ID}
genotype_dir=$1
phased_dir=$2
tag=$3
#tag=${tag}_3
map=$4

eagle \
--vcf=${genotype_dir}/bcf/chr${chr}.${tag}.bcf \
--geneticMapFile=${map} \
--outPrefix=${phased_dir}/chr${chr}.${tag}_phased \
--allowRefAltSwap \
--numThreads 16 \
--vcfOutFormat=z

