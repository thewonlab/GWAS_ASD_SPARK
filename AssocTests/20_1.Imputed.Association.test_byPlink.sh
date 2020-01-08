#!/usr/bin/bash
##SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH --time=01:00:00
#SBATCH -o 20GWAS/201905/trio_4/plink/assoc_%a_HDS_20191104.log

module load plink/2.00a-20190527
gwasdir="20GWAS/201905/trio_4"
impdir="02IMPUTATION/imputed/20190423/20190624/plink"
chr=${SLURM_ARRAY_TASK_ID}
rsidfile="02IMPUTATION/imputed/20190423/20190530/trios/chr${chr}.pos.id.tsv"
pgen="${impdir}/chr${chr}_HDS"

swithflag=2
#1 : fullset
#2 : population specific

if [[ swithflag -eq 1 ]]; then
# for model1 (rm poor quality cases and parents)
plink2 --pgen ${pgen}.pgen \
--psam ${gwasdir}/plink/20190423_20190624.psam \
--pvar ${pgen}.pvar \
--remove-fam ${gwasdir}/plink/20190423_20190503v1.VIP.fam \
--remove 20GWAS/201905/trio_4/plink/20190423_20190503v1_exindiv_errtrios.indiv \
--update-name ${rsidfile} 6 1 \
--minimac3-r2-filter 0.5 --maf 0.01 minor \
--glm cols=chrom,pos,ref,alt,a1freq,a1freqcc,test,nobs,beta,orbeta,se,p \
--out ${gwasdir}/plink/chr${chr}_model1QC.assoc
elif [[ swithflag -eq 2 ]]; then
## for model1 (rm poor quality cases and parents)
plink2 --pgen ${pgen}.pgen \
--psam ${gwasdir}/plink/20190423_20190624.psam \
--pvar ${pgen}.pvar \
--keep 20GWAS/201905/trio_4/plink/20190423_20190503v1_model1EUR5SD.final.indiv \
--update-name ${rsidfile} 6 1 \
--minimac3-r2-filter 0.5 --maf 0.01 minor \
--glm cols=chrom,pos,ref,alt,a1freq,a1freqcc,test,nobs,beta,orbeta,se,p \
--out ${gwasdir}/plink/chr${chr}_model1QCEUR5SD.assoc
plink2 --pgen ${pgen}.pgen \
--psam ${gwasdir}/plink/20190423_20190624.psam \
--pvar ${pgen}.pvar \
--keep 20GWAS/201905/trio_4/plink/20190423_20190503v1_model1EAS5SD.final.indiv \
--update-name ${rsidfile} 6 1 \
--minimac3-r2-filter 0.5 --maf 0.01 minor \
--glm cols=chrom,pos,ref,alt,a1freq,a1freqcc,test,nobs,beta,orbeta,se,p \
--out ${gwasdir}/plink/chr${chr}_model1QCEAS5SD.assoc
plink2 --pgen ${pgen}.pgen \
--psam ${gwasdir}/plink/20190423_20190624.psam \
--pvar ${pgen}.pvar \
--keep 20GWAS/201905/trio_4/plink/20190423_20190503v1_model1AFR5SD.final.indiv \
--update-name ${rsidfile} 6 1 \
--minimac3-r2-filter 0.5 --maf 0.01 minor \
--glm cols=chrom,pos,ref,alt,a1freq,a1freqcc,test,nobs,beta,orbeta,se,p \
--out ${gwasdir}/plink/chr${chr}_model1QCAFR5SD.assoc
fi
