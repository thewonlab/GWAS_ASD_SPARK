#!/usr/bin/bash
#SBATCH -c 4
#SBATCH --mem=60g
#SBATCH -o 50LDSC/Heritability/slurm-h2.log
module load ldsc

eur_ld=" /nas/longleaf/apps/ldsc/1.0.0/ldsc/eur_w_ld_chr/"
LDSC="/nas/longleaf/apps/ldsc/1.0.0/ldsc/ldsc.py"

#(4097+18381)/(4097+4097+18381+27969)
#[1] 0.4121077

phenos="SPARK_EUR_iPSYCH_PGC"
sumstats="50LDSC/sumstats/SPARK_EUR_iPSYCH_PGC_Meta.sumstats.gz"
ldsc.py \
--h2 ${sumstats} \
--ref-ld-chr ${eur_ld} \
--w-ld-chr ${eur_ld} \
--samp-prev 0.4121077 \
--pop-prev 0.012 \
--out 50LDSC/Heritability/${phenos}_h2

