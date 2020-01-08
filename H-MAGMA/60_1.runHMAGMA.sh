#!/usr/bin/bash
#SBATCH -c 4
#SBATCH --mem=50g
#SBATCH -o 60HMAGMA/SPARK_EUR_Meta.log

output="60HMAGMA/SPARK_EUR_Meta"
summary="50LDSC/input/SPARK_EUR_iPSYCH_PGC_Meta.input"
BFILE_EUR="/proj/hyejunglab/program/magma/ref_pop/g1000_eur/g1000_eur"

module load magma/1.07b

magma --bfile ${BFILE_EUR} \
--pval ${summary} use=SNP,P ncol=N \
--gene-annot /proj/hyejunglab/crossdisorder/annotation/FB_wointron.genes.annot \
--out ${output}_MAGMA_FB

magma --bfile ${BFILE_EUR} \
--pval ${summary} use=SNP,P ncol=N \
--gene-annot /proj/hyejunglab/crossdisorder/annotation/AB_wointron.genes.annot \
--out ${output}_MAGMA_AB
