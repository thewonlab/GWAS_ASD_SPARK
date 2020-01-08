#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH -o 99log/02_01_20190514.SNPQC1.log
#SBATCH -e 99log/02_01_20190514.SNPQC1.err

#inputbed
subset="20190503v1"
inputbed="02_AllIndivs/${subset}/SPARK.30K.array_genotype.20190423"
out="02_AllIndivs/${subset}/SPARK.30K.array_genotype.20190423_noYMt"

module load plink/1.90b3 
module load r

plink \
--bfile ${inputbed} \
--chr 1-23 \
--make-bed \
--out ${out}

plink \
--bfile ${out} \
--missing \
--out ${out}_miss

Rscript Script/ckMissingness.R ${out}_miss png 98Plots/${subset}_nonQCed

plink \
--bfile ${out} \
--geno 0.1 \
--make-bed \
--out ${out}_QC1
