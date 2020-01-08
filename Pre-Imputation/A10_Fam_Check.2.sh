#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH -o 99log/02_10_20190530.SpecificQC.log
#SBATCH -e 99log/02_10_20190530.SpecificQC.err

subset="20190503v1"
inddir="02_AllIndivs/${subset}"
root="SPARK.30K.array_genotype.20190423_noYMt_QC4"
triodir="01_Trios/${subset}"
unrelateddir="03_Unrelated/${subset}"

module load plink/1.90b3 

plink \
--bfile ${triodir}/${root}_AllTrios \
--extract ${triodir}/${root}_TriosQCedSNP.snplist \
--filter-nonfounders \
--filter-controls \
--make-bed \
--out ${triodir}/${root}_Trios_noASDSib

cat ${triodir}/${root}_Trios_noASDSib.fam | cut -d" " -f1,2 > ${triodir}/${root}_Trios_noASDSib.list

plink \
--bfile ${triodir}/${root}_AllTrios \
--extract ${triodir}/${root}_TriosQCedSNP.snplist \
--remove ${triodir}/${root}_Trios_noASDSib.list \
--make-bed \
--out ${triodir}/${root}_Trios_ASDonly

plink \
--bfile ${triodir}/${root}_Trios_ASDonly \
--mendel summaries-only \
--out ${triodir}/${root}_Trios_ASDonly_mendelck

cat ${triodir}/${root}_Trios_ASDonly_mendelck.fmendel| perl -pe 's/ +/\t/g'|cut -f2|grep -v FID > ${triodir}/${root}_Trios_ASDonly_Perfect.list

plink \
--bfile ${triodir}/${root}_Trios_ASDonly \
--keep-fam ${triodir}/${root}_Trios_ASDonly_Perfect.list \
--make-bed \
--out ${triodir}/${root}_Perfecttrios_ASDonly

##FOR Unrelated 
plink \
--bfile ${inddir}/${root}_Phen \
--remove-fam ${triodir}/${root}_families.list \
--make-bed \
--out ${unrelateddir}/${root}_unrelated

plink \
--bfile ${unrelateddir}/${root}_unrelated \
--filter-cases \
--hwe 0.0000000001 include-nonctrl \
--write-snplist \
--out ${unrelateddir}/${root}_unrelated_cases_QCedSNPs

plink \
--bfile ${unrelateddir}/${root}_unrelated \
--filter-controls \
--hwe 0.000001 \
--write-snplist \
--out ${unrelateddir}/${root}_unrelated_controls_QCedSNPs

wc -l  ${unrelateddir}/${root}_unrelated_controls_QCedSNPs
wc -l  ${unrelateddir}/${root}_unrelated_cases_QCedSNPs
