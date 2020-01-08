#!/usr/bin/bash
#SBATCH -c 2
#SBATCH --mem=10g
#SBATCH -o 50LDSC/sumstats/slurm_20191104_3.log

MUNGE="/nas/longleaf/apps/ldsc/1.0.0/ldsc/munge_sumstats.py"
SNPLIST="/nas/longleaf/apps/ldsc/1.0.0/ldsc/eur_w_ld_chr/w_hm3.snplist"
LDSC="/nas/longleaf/apps/ldsc/1.0.0/ldsc/ldsc.py"
LDSC_EUR="/nas/longleaf/apps/ldsc/1.0.0/ldsc/eur_w_ld_chr/"
ind="50LDSC/input"
outd="50LDSC/sumstats"

module load ldsc

for i in SPARK_EUR_iPSYCH_PGC_Meta SPARK_EUR;do
 input="${ind}/${i}.input"
 sumstats="${outd}/${i}"
 ${MUNGE} --sumstats ${input} --merge-alleles ${SNPLIST} --out ${sumstats}
done
