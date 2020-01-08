#!/usr/bin/bash

PHASED=$1
BASE=$2
QC=$3
MAP=$4

CONF="/nas/longleaf/home/nanam/ongoing/conf"
CHR=${SLURM_ARRAY_TASK_ID}
TRIOCASES=${BASE}.cases_used_to_make_pseudo_control

module use $HOME/modulefiles
module load tabix
module load samtools
module load plink
module load bcftools
module load eagle
cd ${PHASED}
plink --vcf chr${CHR}.${QC}_phased.vcf.gz --make-bed --remove ${CONF}/${TRIOCASES} --keep-allele-order --out trios/tmp/chr${CHR}.nottrios
cd trios/tmp
plink --bfile chr${CHR}.nottrios --bmerge chr${CHR}.${QC}.trios.pseudo.tucc --keep-allele-order --merge-mode 5 --out chr${CHR}.${QC}.all_w_pseudo
mkdir -p bcf
plink --bfile chr${CHR}.${QC}.all_w_pseudo --recode vcf --keep-allele-order --out bcf/chr${CHR}.${QC}.all_w_pseudo
bgzip -f bcf/chr${CHR}.${QC}.all_w_pseudo.vcf
tabix -pvcf bcf/chr${CHR}.${QC}.all_pseudo.vcf.gz

bcftools convert bcf/chr${CHR}.${QC}.all_w_pseudo.vcf.gz -Ob -o bcf/chr${CHR}.${QC}.all_w_pseudo.bcf
bcftools index -t bcf/chr${CHR}.${QC}.all_w_pseudo.bcf

cd ../../
mkdir -p ALL_w_pseudo/tmp

eagle \
--vcf=trios/tmp/bcf/chr${CHR}.${QC}.all_w_pseudo.bcf \
--geneticMapFile=${MAP} \
--outPrefix=ALL_w_pseudo/tmp/chr${CHR}.${QC}.all_w.pseudo_phased \
--allowRefAltSwap \
--numThreads 16 \
--vcfOutFormat=z

zcat ALL_w_pseudo/tmp/chr${CHR}.${QC}.all_w.pseudo_phased.vcf.gz |perl -pe 's/^/chr/' | bgzip -c > ALL_w_pseudo/chr${CHR}.${QC}.all_w.pseudo_phased.vcf.gz 

