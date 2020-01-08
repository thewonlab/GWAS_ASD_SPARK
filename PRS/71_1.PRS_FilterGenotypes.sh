#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH --time=2-00:00:00

BASE_FOLDER="/path/to/my/input/plink/data"
GWAS_DIR="20GWAS/201905/trio_4/plink"
GENO_DIR="70PRS/01geno/ALL_CC"
PRS_DIR="70PRS/03PRSinput/ALL_CC"
QC_DIR="70PRS/02genoQC/ALL_CC"
IMP_DIR="02IMPUTATION/imputed/20190423/20190624/plink"
IND="70PRS/00conf/Fams_CC.txt"

module load plink/2.00a-20190527

## (1) Make dataset
for chr in `seq 1 22`;do
pgen="${IMP_DIR}/chr${chr}_HDS"
rsidfile="02IMPUTATION/imputed/20190423/20190530/trios/chr${chr}.pos.id.tsv"
plink2 --pgen ${pgen}.pgen \
--psam ${GWAS_DIR}/20190423_20190624.psam \
--pvar ${pgen}.pvar \
--keep ${IND} \
--pheno ${IND} \
--update-name ${rsidfile} 6 1 \
--minimac3-r2-filter 0.5 --maf 0.05 minor \
--make-pgen \
--out ${GENO_DIR}/chr${chr}
done

## (2) filter snps for --geno 0, --maf 0.05, and --hardy --hwe 1e-6
plink2 --pfile ${GENO_DIR}/chr1 --nonfounders --geno 0 --maf 0.05 minor --hardy --hwe 1e-6 --make-bed --out ${QC_DIR}/chr1
for chr in `seq 2 22`;do
plink2 --pfile ${GENO_DIR}/chr${chr} --nonfounders --geno 0 --maf 0.05 minor --hwe 1e-6 --make-bed --out ${QC_DIR}/chr${chr}
echo "${QC_DIR}/chr${chr}" |awk '{print $1".bed",$1".bim",$1".fam"}' >> ${QC_DIR}/auto.bedlist 
done

## (3) merge files genotype PCs 
module load plink
plink --bfile ${QC_DIR}/chr1 --merge-list ${QC_DIR}/auto.bedlist  --make-bed --out ${QC_DIR}/auto

## (4) generate plink genotype PCs 
plink --bfile ${QC_DIR}/auto \
--keep ${IND} \
--exclude range 00conf/exclude_regions \
--hwe 0.001 \
--indep-pairwise 50 5 0.2 \
--out ${QC_DIR}/auto_tmp_CaseOnly

plink --bfile ${QC_DIR}/auto \
--extract ${QC_DIR}/auto_tmp_CaseOnly.prune.in \
--keep ${IND} \
--make-bed \
--out ${QC_DIR}/auto_pruned_CaseOnly

plink --bfile ${QC_DIR}/auto_pruned_CaseOnly --pca 10 --out ${QC_DIR}/auto_pruned_PCA_CaseOnly

