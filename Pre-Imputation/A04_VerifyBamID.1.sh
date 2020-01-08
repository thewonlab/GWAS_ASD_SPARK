#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH -o 99log/04_01_20190521.PrepVerifyBamID.log
#SBATCH -e 99log/04_01_20190521.PrepVerifyBamID.err

dir="02_AllIndivs/20190503v1"
out="${dir}/ZZ_tmp_verifyBAMID"
bed="/pine/scr/h/j/hjwon/spark/SPARK_Freeze_Three_update_20190423/included/reference_files/xgen_plus_spikein.b38_pm50.bed"
cat ${bed} |awk '{print $1,$2,$3,$1"_"$2"_"$3}'|perl -pe 's/ /\t/g' > ${out}/target.bed

module load plink/1.90b3 
plink \
--bfile ${dir}/SPARK.30K.array_genotype.20190423_noYMt_QC3 \
--out ${out}/SPARK.30K.array_genotype.20190423_noYMt_QC3_exome.onlySNPs \
--snps-only \
--extract range ${out}/target.bed \
--recode vcf-iid 

module load bcftools
module load htslib  
bgzip ${out}/SPARK.30K.array_genotype.20190423_noYMt_QC3_exome.onlySNPs.vcf
