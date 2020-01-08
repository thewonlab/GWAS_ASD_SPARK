#!/usr/bin/bash
#SBATCH -c 4
#SBATCH --mem=60g

module load ldsc

LDSC="/nas/longleaf/apps/ldsc/1.0.0/ldsc/ldsc.py"
sumstats="50LDSC/sumstats/SPARK_EUR_iPSYCH_PGC_Meta.sumstats.gz"
FRQ="/proj/hyejunglab/program/ldsc/LDSC/1000G_Phase3_frq/1000G.EUR.QC."
WEIGHT="/proj/hyejunglab/program/ldsc/LDSC/weights_hm3_no_hla/weights."
BASELINE="/proj/hyejunglab/program/ldsc/LDSC/baselineLD_v1.1/baselineLD."

pt="50LDSC/Partitioned_Heritability/SPARK_EUR_iPSYCH-PGC_Meta_chromHMM"
REFLD="/proj/hyejunglab/crossdisorder/LDSC/partherit/annot_chromHMM/,${BASELINE}"

${LDSC} --h2 ${sumstats} --out ${pt} --frqfile-chr ${FRQ} --overlap-annot --ref-ld-chr ${REFLD} --w-ld-chr ${WEIGHT} 

pt="50LDSC/Partitioned_Heritability/SPARK_EUR_iPSYCH-PGC_Meta_GZ_CP_NMatched"
REFLD="50LDSC/dataset/GZ_CP_diff_NMatched/,${BASELINE}"

${LDSC} --h2 ${sumstats} --out ${pt} --frqfile-chr ${FRQ} --overlap-annot --ref-ld-chr ${REFLD} --w-ld-chr ${WEIGHT} 
