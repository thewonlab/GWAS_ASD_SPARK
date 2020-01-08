#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH -o 99log/02_08_20190523.SpecificQC.log
#SBATCH -e 99log/02_08_20190523.SpecificQC.err

subset="20190503v1"
inddir="02_AllIndivs/${subset}"
root="SPARK.30K.array_genotype.20190423_noYMt_QC4"
triodir="01_Trios/${subset}"
unrelateddir="03_Unrelated/${subset}"

mkdir -p ${triodir}
mkdir -p ${unrelateddir}

module load plink/1.90b3 

cat ${inddir}/${root}_mendelck.fmendel| perl -pe 's/ +/\t/g'|cut -f2|grep -v FID > ${triodir}/${root}_families.list

#FOR TRIOS
plink \
--bfile ${inddir}/${root}_Phen \
--keep-fam ${triodir}/${root}_families.list \
--make-bed \
--out ${triodir}/${root}_AllTrios

plink \
--bfile ${triodir}/${root}_AllTrios \
--mendel summaries-only \
--out ${triodir}/${root}_AllTrios_mendelck

cat ${triodir}/${root}_AllTrios_mendelck.lmendel |perl -pe 's/ +/\t/g' |awk '$3>4' |grep -v SNP |cut -f3 > ${triodir}/${root}_AllTrios_mendelck.lmendel.errSNP

plink \
--bfile ${triodir}/${root}_AllTrios \
--exclude ${triodir}/${root}_AllTrios_mendelck.lmendel.errSNP \
--hwe 0.000001 \
--write-snplist \
--out ${triodir}/${root}_TriosQCedSNP

# Check if probands and sibling were genetically fully overoapped
plink \
--bfile ${triodir}/${root}_AllTrios \
--extract ${triodir}/${root}_TriosQCedSNP.snplist \
--exclude range 00conf/exclude_regions \
--maf 0.05 \
--hwe 0.001 \
--chr 1-22 \
--indep-pairwise 50 5 0.2 \
--out ${triodir}/tmp

plink \
--bfile ${triodir}/${root}_AllTrios \
--extract ${triodir}/tmp.prune.in \
--make-bed \
--out ${triodir}/${root}_TrioQCed_pruned

plink \
--bfile ${triodir}/${root}_TrioQCed_pruned \
--genome gz rel-check \
--out ${triodir}/${root}_TrioQCed_pruned.g 

