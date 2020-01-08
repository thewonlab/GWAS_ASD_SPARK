#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH -o 99log/02_11_20190731.GettagSNP_Trios.log
#SBATCH -e 99log/02_11_20190731.GettagSNP_Trios.err

module load plink/1.90b3 

subset="20190503v1"
ind="02_AllIndivs/${subset}"
out="01_Trios/${subset}"
base="SPARK.30K.array_genotype.20190423_noYMt_QC4"
HM3Dir="/nas/longleaf/home/nanam/PROJECT/00ASD_SPARK/spark-work/01QC/02_Reference/01HapMap/01QC"
HM3list="${HM3Dir}/HM3.unamb.SNPlist"
HM3bim="${HM3Dir}/HM3_Hg38_noAmbig"
finalset="../../20GWAS/201905/trio_4/plink/20190423_20190503v1_model1.final.cases_oneindiv_from_pedigree"

plink \
--bfile ${ind}/${base} \
--keep ${finalset} \
--geno 0.05 \
--maf 0.01 \
--hwe 0.000001 \
--make-bed \
--out ${out}/${base}.Tag

awk '{ if (($5=="T" && $6=="A")||($5=="A" && $6=="T")||($5=="C" && $6=="G")||($5=="G" && $6=="C")) print $2, "ambig" ; else print $2 ;}' ${out}/${base}.Tag.bim | grep -v ambig > ${out}/${base}.Tag.unamb.SNPlist

plink \
--bfile ${out}/${base}.Tag \
--extract $HM3list \
--make-bed \
--out ${out}/${base}_local

