#!/usr/bin/bash
#SBATCH -c 4
#SBATCH --mem=50g
#SBATCH -o 02IMPUTATION/QC/20190423/20190731_ALL/plink/preparation_2_chr%a.log

output="02IMPUTATION/QC/20190423/20190731_ALL/plink"
wes="02IMPUTATION/QC/20190423/20190624/plink"
gwasdir="20GWAS/201905/trio_2"
chr=${SLURM_ARRAY_TASK_ID}
pgen="02IMPUTATION/imputed/20190423/20190624/plink/chr${chr}_HDS"

module load plink/2.00a-20190527
module use $HOME/modulefiles
module load htslib
module load vcftools/0.1.15                 
skip=0

if [[ skip -eq 0 ]]; then
 plink2 --pgen ${pgen}.pgen --psam ${gwasdir}/plink/20190423_20190624.psam --pvar ${pgen}.pvar --max-alleles 2 --snps-only --make-pgen --out ${output}/chr${chr}.imputed --threads 4 -memory 30000
 mv ${output}/chr${chr}.imputed.psam ${output}/chr${chr}.imputed.psam.tmp && cat ${output}/chr${chr}.imputed.psam.tmp |perl -pe 's/(.*)\t(.*)_(.*)-T/$1\t$3/' |cut -f2,3 > ${output}/chr${chr}.imputed.psam
 plink2 --pgen ${wes}/chr${chr}.exome.pgen --psam ${wes}/chr${chr}.exome.psam --pvar ${wes}/chr${chr}.exome.pvar --snps-only --max-alleles 2 --make-pgen --out ${output}/chr${chr}.exome
# make snplist exists in exome seq data
 plink2 --pgen ${output}/chr${chr}.exome.pgen --psam ${output}/chr${chr}.exome.psam --pvar ${output}/chr${chr}.exome.pvar --write-snplist  --out ${output}/chr${chr}.exome_SNP
 mv ${output}/chr${chr}.imputed.psam ${output}/chr${chr}.imputed.psam.tmp2 && cat ${output}/chr${chr}.imputed.psam.tmp2 |perl -pe 's/^IID/#IID/' > ${output}/chr${chr}.imputed.psam
 mv ${output}/chr${chr}.imputed.pvar ${output}/chr${chr}.imputed.pvar.tmp && cat ${output}/chr${chr}.imputed.pvar.tmp |perl -pe 's/:/_/g;s/chr//;' > ${output}/chr${chr}.imputed.pvar

fi
grep -v "#" ${output}/chr${chr}.imputed.pvar |grep TYPED |cut -f3 > ${output}/chr${chr}.imputed.TYPED
grep -vf  ${output}/chr${chr}.imputed.TYPED ${output}/chr${chr}.exome_SNP.snplist > ${output}/chr${chr}.imputed.ImputedOnly.snplist

