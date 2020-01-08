#!/usr/bin/bash
#SBATCH -c 2
#SBATCH --mem=10g

MUNGE="/nas/longleaf/apps/ldsc/1.0.0/ldsc/munge_sumstats.py"
SNPLIST="/nas/longleaf/apps/ldsc/1.0.0/ldsc/eur_w_ld_chr/w_hm3.snplist"
LDSC="/nas/longleaf/apps/ldsc/1.0.0/ldsc/ldsc.py"
LDSC_EUR="/nas/longleaf/apps/ldsc/1.0.0/ldsc/eur_w_ld_chr/"
OUT="50LDSC/correlation/PSYCH/ASD_ASD"

module load ldsc

#Part 1 across ASD studies
sumstats="50LDSC/sumstats/SPARK_EUR"

#iPSYCH + PGC vs SPARK
comp="/proj/hyejunglab/crossdisorder/LDSC/sumstat/asd2.sumstats.gz"
corr="${OUT}/SPARK_EUR_iPSYCH_PGC"
${LDSC} --rg ${sumstats}.sumstats.gz,${comp} --ref-ld-chr ${LDSC_EUR} --w-ld-chr ${LDSC_EUR} --out ${corr}

# PGC vs SPARK
comp="50LDSC/sumstats/ASD_Mol_EUR.2017.sumstats.gz"
corr="${OUT}/SPARK_EUR_PGC_Mol2017"
${LDSC} --rg ${sumstats}.sumstats.gz,${comp} --ref-ld-chr ${LDSC_EUR} --w-ld-chr ${LDSC_EUR} --out ${corr}

# ipsych vs SPARK
comp="/proj/hyejunglab/crossdisorder/LDSC/sumstat/asd_ipsych.sumstats.gz"
corr="${OUT}/SPARK_EUR_iPSYCH"
${LDSC} --rg ${sumstats}.sumstats.gz,${comp} --ref-ld-chr ${LDSC_EUR} --w-ld-chr ${LDSC_EUR} --out ${corr}
sumstats="/proj/hyejunglab/crossdisorder/LDSC/sumstat/asd_ipsych.sumstats.gz"

# ispych vs PGC
comp="50LDSC/sumstats/ASD_Mol_EUR.2017.sumstats.gz"
corr="${OUT}/iPSYCH_PGC_Mol2017"
${LDSC} --rg ${sumstats},${comp} --ref-ld-chr ${LDSC_EUR} --w-ld-chr ${LDSC_EUR} --out ${corr}

# Part 2 among Psychiatric diseases
sumstats="50LDSC/sumstats/SPARK_EUR_iPSYCH_PGC_Meta.sumstats.gz"

for target in adhd2 bp2019 scz3 mdd.2019 cannabis alcohol.GSCAN.2019 smoking.GSCAN.2019 ad.jansen pd2019 iq.Savage Neuroticism.CTG.2018;do
 comp="/proj/hyejunglab/crossdisorder/LDSC/sumstat/${target}.sumstats.gz"
 corr="50LDSC/correlation/ASD_SPARK_EUR_iPSYCH_PGC_Meta_${target}"
 ${LDSC} --rg ${sumstats},${comp} --ref-ld-chr ${LDSC_EUR} --w-ld-chr ${LDSC_EUR} --out ${corr}
done

sumstats="50LDSC/sumstats/SPARK_EUR_iPSYCH_PGC_Meta"

#ENIGMACHARGE
for target in CHARGE-ENIGMA-ICVheight-METAANALYSIS-201503301_wrsID.TBL ENIGMA-CHARGE_Zscore_ICV_20150324_noGC_1.final;do
sumstats="50LDSC/sumstats_Multiplechildren/SPARK_EUR_iPSYCH_PGC_Meta"
comp="/proj/steinlab/projects/ENIGMACHARGE/${target}.sumstats.gz"
corr="50LDSC/correlation/PSYCH/ASD_SPARK_EUR_iPSYCH_PGC_Meta_${target}"
${LDSC} --rg ${sumstats}.sumstats.gz,${comp} --ref-ld-chr ${LDSC_EUR} --w-ld-chr ${LDSC_EUR} --out ${corr}
done
