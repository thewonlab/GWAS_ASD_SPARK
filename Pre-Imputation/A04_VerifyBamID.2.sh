#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=5g
#SBATCH -o 99log/02_04_02_20190522_VerifyBamID_%A_%a.log
#SBATCH -e 99log/02_04_02_20190522_VerifyBamID_%A_%a.err

i=${SLURM_ARRAY_TASK_ID}
tgtfile=$1

ref="/pine/scr/h/j/hjwon/spark/spark-work/genome.hg38rg.fa"
orig_dir="/pine/scr/n/a/nanam/spark/spark-work/SPARK_Freeze_Three_update_20190423/wes.CRAM"
tmp_dir="02_AllIndivs/20190503v1/ZZ_tmp_verifyBAMID"
CHIP="SPARK.30K.array_genotype.20190423_noYMt_QC3_exome.onlySNPs.vcf.gz"

module load samtools/1.9   
module use $HOME/modulefiles                  
module load verifyBamID 

while IFS=' ' read -a args; do
 seqn="${args[2]}" 
 chipn="${args[1]}" 
 cp -p ${orig_dir}/${i}/${seqn}.cram ${tmp_dir}/${i}/
 samtools index ${tmp_dir}/${i}/${seqn}.cram
 samtools view -b -T ${ref} ${tmp_dir}/${i}/${seqn}.cram -o ${tmp_dir}/${i}/${seqn}.bam
 samtools index ${tmp_dir}/${i}/${seqn}.bam
 verifyBamID --bam ${tmp_dir}/${i}/${seqn}.bam --vcf ${tmp_dir}/${CHIP} --maxDepth 1000 --precise --ignoreRG --noPhoneHome --out ${tmp_dir}/${i}/${seqn} --smID ${chipn}
 rm ${tmp_dir}/${i}/${seqn}.cram*
 rm ${tmp_dir}/${i}/${seqn}.bam*
done < ${tmp_dir}/${i}/${tgtfile}
