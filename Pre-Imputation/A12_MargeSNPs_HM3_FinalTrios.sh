#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH -o 99log/02_12_20190801.MargeSNP_Trios.log
#SBATCH -e 99log/02_12_20190801.MargeSNP_Trios.err

module load plink/1.90b3 

subset="20190503v1"
root="01_Trios/${subset}/SPARK.30K.array_genotype.20190423_noYMt_QC4"
HM3Dir="/nas/longleaf/home/nanam/PROJECT/00ASD_SPARK/spark-work/01QC/02_Reference/01HapMap/01QC"
HM3bim="${HM3Dir}/HM3_Hg38_noAmbig"

plink \
--bfile ${HM3bim} \
--extract ${root}.Tag.unamb.SNPlist \
--make-bed \
--out ${root}_HM3

plink \
--bfile ${root}_local \
--bmerge ${root}_HM3.bed ${root}_HM3.bim ${root}_HM3.fam \
--make-bed \
--out ${root}_MDS

plink \
--bfile ${root}_local \
--flip ${root}_MDS-merge.missnp \
--make-bed \
--out ${root}_flipped 

plink \
--bfile ${root}_flipped \
--bmerge ${root}_HM3.bed ${root}_HM3.bim ${root}_HM3.fam \
--make-bed \
--out ${root}_MDS2
