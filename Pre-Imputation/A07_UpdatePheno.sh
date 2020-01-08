#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=1g
#SBATCH -o 99log/02_07_20190523.updatePheno.log
#SBATCH -e 99log/02_07_20190523.updatePheno.err

pheno="00conf/SPARK.30K.array_genotype.20190423"
grep -v sfid /pine/scr/h/j/hjwon/spark/SPARK_Freeze_Three_update_20190423/included/SPARK.27K.mastertable.20190501.txt |cut -f1,2,6 > ${pheno}

subset="20190503v1"
outd="02_AllIndivs/${subset}"
root="${outd}/SPARK.30K.array_genotype.20190423_noYMt_QC4"

module load plink/1.90b3 

plink \
--bfile ${root} \
--make-pheno $pheno '2' \
--make-bed \
--out ${root}_Phen

