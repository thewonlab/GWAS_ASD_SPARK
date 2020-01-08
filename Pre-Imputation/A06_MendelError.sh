#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=10g
#SBATCH -o 99log/02_06_20190523.mendelError.log
#SBATCH -e 99log/02_06_20190523.mendelError.err

module load plink/1.90b3 

subset="20190503v1"
outd="02_AllIndivs/${subset}"
root="${outd}/SPARK.30K.array_genotype.20190423_noYMt_QC4"

plink \
--bfile ${root} \
--mendel summaries-only \
--out ${root}_mendelck

