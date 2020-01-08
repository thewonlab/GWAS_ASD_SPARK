#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=10g
#SBATCH --time=5:00:00

module load vcftools

vcfdir="/nas/longleaf/home/nanam/PROJECT/00ASD_SPARK/SPARK_Freeze_Three_update_20190423/included/wes.gVCF/"

indiv=$1
gvcf=$2
dir=$3

vcftools --gzvcf ${gvcf} --out ${dir}/${indiv}.X --chr X --remove-indels --remove-filtered-all --depth
vcftools --gzvcf ${gvcf} --out ${dir}/${indiv}.Y --chr Y --remove-indels --remove-filtered-all --depth
vcftools --gzvcf ${gvcf} --out ${dir}/${indiv}.A --not-chr X --not-chr Y --remove-indels --remove-filtered-all --depth
