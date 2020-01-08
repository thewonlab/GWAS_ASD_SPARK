#!/usr/bin/bash
#SBATCH -c 8
#SBATCH --mem=50g
#SBATCH -o 02IMPUTATION/QC/20190423/20190731_ALL/plink/compare_genotypes_20191119_2_%a.log

output="02IMPUTATION/QC/20190423/20190712_ALL/plink"
output2="02IMPUTATION/QC/20190423/20190731_ALL/plink"
chr=${SLURM_ARRAY_TASK_ID}

module load plink/2.00a-20190527
module use $HOME/modulefiles
module load htslib
module load vcftools/0.1.15

for rsq in 0.5 0.7 0.9;do
 mv ${output}/chr${chr}.imputed.psam ${output}/chr${chr}.imputed.psam.tmp && cat ${output}/chr${chr}.imputed.psam.tmp |perl -pe 's/.*_//' >  ${output}/chr${chr}.imputed.psam
 plink2 --pfile ${output}/chr${chr}.imputed --extract ${output}/chr${chr}.imputed.ImputedOnly.snplist --minimac3-r2-filter ${rsq} --maf 0.01 minor --write-snplist --out ${output2}/chr${chr}.imputed_exome_common_rsq${rsq}_s

 plink2 --pfile ${output}/chr${chr}.imputed --extract ${output2}/chr${chr}.imputed_exome_common_rsq${rsq}_s.snplist --export vcf --out ${output2}/chr${chr}.imputed_exome_common_rsq${rsq}
 bgzip -c ${output2}/chr${chr}.imputed_exome_common_rsq${rsq}.vcf > ${output2}/chr${chr}.imputed_exome_common_rsq${rsq}.vcf.gz
 tabix -p vcf ${output2}/chr${chr}.imputed_exome_common_rsq${rsq}.vcf.gz

 plink2 --pfile ${output}/chr${chr}.exome --extract ${output2}/chr${chr}.imputed_exome_common_rsq${rsq}_s.snplist --export vcf --out ${output2}/chr${chr}.exome_imputed_common_rsq${rsq}
 bgzip -c ${output2}/chr${chr}.exome_imputed_common_rsq${rsq}.vcf > ${output2}/chr${chr}.exome_imputed_common_rsq${rsq}.vcf.gz
 tabix -p vcf ${output2}/chr${chr}.exome_imputed_common_rsq${rsq}.vcf.gz

 vcf-compare -g ${output2}/chr${chr}.imputed_exome_common_rsq${rsq}.vcf.gz ${output2}/chr${chr}.exome_imputed_common_rsq${rsq}.vcf.gz > ${output2}/chr${chr}.compare_rsq${rsq}_all_result
 cat ${output2}/chr${chr}.compare_rsq${rsq}_all_result |grep ^GC |cut -f2-7,20-24 > ${output2}/chr${chr}.compare_rsq${rsq}_GC
done
