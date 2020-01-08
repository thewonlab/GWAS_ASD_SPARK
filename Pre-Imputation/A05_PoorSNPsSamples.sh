#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH -o 99log/02_04_03_20190523.SampleContamination.log
#SBATCH -e 99log/02_04_03_20190523.SampleContamination.err

subset="20190503v1"
outd="02_AllIndivs/${subset}"
root="${outd}/SPARK.30K.array_genotype.20190423_noYMt"

rm ${outd}/remove_sample_list_with_sample_contamination.txt
for i in `cat ${outd}/ZZ_tmp_verifyBAMID/*/SP*selfSM |cut -f1,7,12|grep -v NA|awk '$2>0.08||$3>0.08' |cut -f1`;do
cat ${root}.fam |awk -v spid=${i} '{if($2==spid) print $1,$2}' >> ${outd}/remove_sample_list_with_sample_contamination.txt
done

module load plink/1.90b3 

plink \
--bfile ${root}_QC3 \
--remove ${outd}/remove_sample_list_with_sample_contamination.txt \
--geno 0.02 \
--maf 0.01 \
--make-bed \
--out ${root}_QC4
