#!/usr/bin/bash
#SBATCH -p general
#SBATCH --ntasks=1
#SBATCH --mem=50g
#SBATCH --time=2-00:00:00
#SBATCH -o 70PRS/10POOPRS/PC/prep_20190829_2.log

GWAS_DIR="20GWAS/201905/trio_4/plink"
PCA_DIR="70PRS/10POOPRS/PC/"
IMP_DIR="02IMPUTATION/imputed/20190423/20190624/plink"
keep="70PRS/10POOPRS/Target/AllSample.txt" # list of 12,291 individuals from 4,097 trios (fid, iid, without header)
parents="70PRS/10POOPRS/Target/ParentsSample.txt" # list of 8,194 individuals from 4,097 trios (only parents; fid,iid, without header)
cat ${keep} |grep -v T > ${parents}

module load plink/2.00a-20190527

## (1) Make dataset
for chr in `seq 1 22`;do
pgen="${IMP_DIR}/chr${chr}_HDS"
rsidfile="02IMPUTATION/imputed/20190423/20190530/trios/chr${chr}.pos.id.tsv"
plink2 --pgen ${pgen}.pgen \
--psam ${GWAS_DIR}/20190423_20190624.psam \
--pvar ${pgen}.pvar \
--keep ${keep} \
--update-name ${rsidfile} 6 1 \
--minimac3-r2-filter 0.5 --maf 0.05 minor \
--make-pgen \
--out ${PCA_DIR}/chr${chr}
done

## (2) filter snps
plink2 --pfile ${PCA_DIR}/chr1 --nonfounders --geno 0.1 --maf 0.05 minor --hardy --hwe 1e-6 --make-bed --out ${PCA_DIR}/chr1
for chr in `seq 2 22`;do
plink2 --pfile ${PCA_DIR}/chr${chr} --nonfounders --geno 0.1 --maf 0.05 minor --hwe 1e-6 --make-bed --out ${PCA_DIR}/chr${chr}
echo "${PCA_DIR}/chr${chr}" |awk '{print $1".bed",$1".bim",$1".fam"}' >> ${PCA_DIR}/auto.bedlist 
done

#### (3) merge files genotype PCs 
module load plink
plink --bfile ${PCA_DIR}/chr1 --merge-list ${PCA_DIR}/auto.bedlist  --make-bed --out ${PCA_DIR}/auto

#### (4) generate plink genotype PCs 
plink --bfile ${PCA_DIR}/auto \
--keep ${parents} \
--exclude range 00conf/exclude_regions \
--hwe 0.001 \
--indep-pairwise 50 5 0.2 \
--out ${PCA_DIR}/auto_tmp_ParentOnly

plink --bfile ${PCA_DIR}/auto \
--extract ${PCA_DIR}/auto_tmp_ParentOnly.prune.in \
--keep ${parents} \
--make-bed \
--out ${PCA_DIR}/auto_pruned_ParentOnly

plink --bfile ${PCA_DIR}/auto_pruned_ParentOnly --pca 10 --out ${PCA_DIR}/auto_pruned_PCA_ParentOnly
