#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=100g
#SBATCH --time=3:00:00

PHASED=$1
BASE=$2
TWINS=$3
QC=$4


CONF="/nas/longleaf/home/nanam/ongoing/conf"
CHR=${SLURM_ARRAY_TASK_ID}
TRIOS=${BASE}.txt
PHENO=${BASE}.pheno
SEX=${BASE}.sex
FAMILY=${BASE}.family

module load plink
cd ${PHASED}
plink --vcf chr${CHR}.${QC}_phased.vcf.gz --make-bed --keep ${CONF}/${TRIOS} --update-parents ${CONF}/${FAMILY} --update-sex ${CONF}/${SEX} --keep-allele-order --out trios/tmp/chr${CHR}.trios
cd trios
plink --bfile tmp/chr${CHR}.trios --pheno ${CONF}/${PHENO} --keep-allele-order --remove $TWINS --make-bed --out tmp/chr${CHR}.trios.pheno

module use $HOME/modulefiles
module load plink/1.09p_4_Mar_2019
cd tmp
plink --bfile chr${CHR}.trios.pheno --tucc 'write-bed' --keep-allele-order --out chr${CHR}.${QC}.trios.pseudo
mv chr${CHR}.${QC}.trios.pseudo.tucc.fam chr${CHR}.${QC}.trios.pseudo.tucc.fam.tmp
cat chr${CHR}.${QC}.trios.pseudo.tucc.fam.tmp |tr _ - > chr${CHR}.${QC}.trios.pseudo.tucc.fam

module load plink
module load htslib
plink --bfile chr${CHR}.${QC}.trios.pseudo.tucc --keep-allele-order --recode vcf bgz --output-chr chrM --out chr${CHR}.${QC}.trios.pseudo_phased_tmp
cd ../
zcat tmp/chr${CHR}.${QC}.trios.pseudo_phased_tmp.vcf.gz |perl -pe 's/\//\|/g' | bgzip -c > chr${CHR}.${QC}.trios.pseudo_phased.vcf.gz 
