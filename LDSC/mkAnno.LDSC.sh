#!/usr/bin/bash

chr=$1
categ=$2 ## This is the directory for the annotation file

echo $categ

module load ldsc

LDSC="/nas/longleaf/apps/ldsc/1.0.0/ldsc/ldsc.py"

${LDSC} --l2 --bfile /proj/hyejunglab/program/ldsc/LDSC/1000G_EUR_Phase3_plink/1000G.EUR.QC.$chr --ld-wind-cm 1 --annot $categ/$chr.annot.gz --out $categ/$chr --print-snps /proj/hyejunglab/program/ldsc/LDSC/list.txt
