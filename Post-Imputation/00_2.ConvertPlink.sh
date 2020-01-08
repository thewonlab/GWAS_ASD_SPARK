#!/usr/bin/bash
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --mem=96g
#SBATCH --time=5:00:00
#SBATCH -o 02IMPUTATION/imputed/20190423/20190624/plink/convert_%a_HDS.log
#SBATCH -e 02IMPUTATION/imputed/20190423/20190624/plink/convert_%a_HDS.err

module load plink/2.00a-20190527
chr=${SLURM_ARRAY_TASK_ID}
dir="02IMPUTATION/imputed/20190423/20190624"
vcf="${dir}/chr${chr}.dose.vcf.gz"

plink2 --vcf ${vcf} dosage=HDS --make-pgen --out ${dir}/plink/chr${chr}_HDS --threads 4
