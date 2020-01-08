#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH -o 99log/02_03_20190514.SexCheck.log
#SBATCH -e 99log/02_03_20190514.SexCheck.err

subset="20190503v1"
outd="02_AllIndivs/${subset}"
#BASENAME
root="${outd}/SPARK.30K.array_genotype.20190423_noYMt"
bed="${root}_QC2"

module load plink/1.90b3 

plink \
--bfile ${bed} \
--check-sex \
--out ${bed}.sexcheck

grep PROBLEM ${bed}.sexcheck.sexcheck |perl -pe 's/ +/\t/g'|cut -f2- > ${outd}/fail_sex_check.txt

