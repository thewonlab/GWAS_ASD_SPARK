#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=5g
#SBATCH -o 99log/02_03_20190514.rmlowCallRate.log
#SBATCH -e 99log/02_03_20190514.rmlowCallRate.err


subset="20190503v1"
#BASENAME
root="SPARK.30K.array_genotype.20190423_noYMt"
dir="02_AllIndivs/${subset}"
#BEDFILE
bed="${dir}/${root}"

module load plink/1.90b3 

plink \
--bfile ${bed}_QC1 \
--missing \
--out ${bed}_QC1_m

plink \
--bfile ${bed}_QC1 \
--het \
--out ${bed}_QC1_h

plink \
--bfile ${bed}_QC1 \
--mind 0.1 \
--make-bed \
--out ${bed}_QC2

