##!/usr/bin/bash

subset="20190503v1"
root="SPARK.30K.array_genotype.20190423_noYMt_QC4"
triodir="01_Trios/${subset}"
unrelateddir="03_Unrelated/${subset}"

echo "TRIO UnrelatedCtrl UnrelatedCase Common_Unrelated_Ctrl_Case Common_Trio_Unrelated" > 99log/QCedSNP_Num.txt
j=`wc -l ${triodir}/${root}_TriosQCedSNP.snplist`
k=`wc -l ${unrelateddir}/${root}_unrelated_controls_QCedSNPs.snplist`
l=`wc -l ${unrelateddir}/${root}_unrelated_cases_QCedSNPs.snplist >> 99log/QCedSNP_Num.txt`
m=`cat ${unrelateddir}/${root}_unrelated_controls_QCedSNPs.snplist ${unrelateddir}/${root}_unrelated_cases_QCedSNPs.snplist |sort |uniq -c |awk '$1==2' |wc -l`
n=`cat ${unrelateddir}/${root}_unrelated_controls_QCedSNPs.snplist ${unrelateddir}/${root}_unrelated_cases_QCedSNPs.snplist ${triodir}/${root}_TriosQCedSNP.snplist |sort |uniq -c |awk '$1==3' |wc -l` 
echo "$j $k $l $m $n" >> 99log/QCedSNP_Num.txt
touch /nas/longleaf/home/nanam/ongoing/rmlist/extra-fail.sample.20190530
touch /nas/longleaf/home/nanam/ongoing/rmlist/extra-fail.snp.20190530
cat ${unrelateddir}/${root}_unrelated_controls_QCedSNPs.snplist ${unrelateddir}/${root}_unrelated_cases_QCedSNPs.snplist ${triodir}/${root}_TriosQCedSNP.snplist |sort |uniq -c |awk '$1==3' |perl -pe 's/ +/\t/g; s/^\t//;' |cut -f2 > ~/ongoing/rmlist/final.snp.20190530
