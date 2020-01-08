#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH -o 99log/02_03_02_20190521.SexErrRmv.log
#SBATCH -e 99log/02_03_02_20190521.SexErrRmv.err

subset="20190503v1"
outd="02_AllIndivs/${subset}"
root="${outd}/SPARK.30K.array_genotype.20190423_noYMt"

module load plink/1.90b3 

plink \
--bfile ${root}_QC2 \
--remove ${outd}/remove_sample_list_with_sex_mismatched.txt \
--make-bed \
--out ${root}_QC3
