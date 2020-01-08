#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=100g
#SBATCH --time=48:00:00
#SBATCH -o 99log/02_13_20190801.MDSplot.Trios.log
#SBATCH -e 99log/02_13_20190801.MDSplot.Trios.err

subset="20190503v1"
outd="01_Trios/${subset}"
root="${outd}/SPARK.30K.array_genotype.20190423_noYMt_QC4"

module load plink/1.90b3 

plink \
--bfile ${root}_MDS2 \
--cluster \
--mds-plot 4 \
--out ${root}_HM3mds

