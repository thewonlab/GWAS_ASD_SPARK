#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH --time=3-00:00:00

snpsift="/nas/longleaf/apps/snpeff/4.3t/snpEff/SnpSift.jar"
#dbsnp="/pine/scr/h/j/hjwon/spark/spark-work/01QC/02_Reference/00Resources/00-All.vcf.gz"
dbsnp="01QC/02_Reference/00Resources/00-All.vcf.gz"

chr=${SLURM_ARRAY_TASK_ID}
imp="02IMPUTATION/imputed/20190423/20190530/trios/chr${chr}"
target=${imp}.dose.id.vcf.gz
tsvf=${imp}.pos.id.tsv

java -jar ${snpsift} annotate ${dbsnp} ${imp}.dose.vcf.gz |gzip -c >  ${target} 
zcat ${target} |grep -v "#" |cut -f3 |perl -pe 's/:/\t/g;s/;/\t/' |awk '{OFS="\t"}{print $1":"$2":"$3":"$4,$1,$2,$3,$4,$5}'> ${tsvf}
mv ${tsvf} ${tsvf}.tmp
cat ${tsvf}.tmp |awk '{OFS="\t"}{if($6==""){print $0"\t"$1}else{$6=$1"_"$6;print $0}}' > ${tsvf}
