# README

This directory contains codes to run polygenic risk score analyses (PRS)

## Preparation
### Step1: Get parents' information

```{sh}
sbatch --array=1-22 ./40_1.UpdateParentIdForPOO.sh
Rscript 41_1.prepremin.R
```

### Step2: Classification of families
Classification of families by family structure and affected status of individuals

```{sh}
Rscript 71_0.SubGroup.R
```

### Step3: QC of SNPs for PRS

```{sh}
sbatch --array=1-22 ./71_1.PRS_FilterGenotypes.sh
```

### Step4: Run [PRSice-2](http://prsice.info)

```{sh}
SUMSTAT="../../../03PRSinput/GWAS/iPSYCHPGC_HG38_update_model1QC_EUR_only"
NAME="ASD_SPARK_EUR_SPARK"
BASE_FOLDER="70PRS/04PRS_WKDIR/prsice/rawPRS_CC_QC"
TARGET="../../../02genoQC/ALL/auto"

./71_3.runPRS.sh ${SUMSTAT} ${NAME} ${BASE_FOLDER} ${TARGET} 
```

### Step5: Regression 
```{sh}
#1. Get metadata (sex, family type and PCs)
Rscript 72_4_addMetadata.R
#2. Regress out covariates
Rscript 72_5_woPCs.regressCovariates.R
#3. Choose Pvalue threshold
Rscript 72_6_woPCs.choosePvalThresh.R
```

## Evaluation of PRS
 this scripts is to compare PRS (1) between case and pseud-controls, (2) between male vs female, and (3) across family types
```{sh}
Rscript 72_7.evaluatePRS.R
```

## Parental origin PRS analyses
### Step1: Devide individuals into family units
```{sh}
Rscript 7B_0.devideTrios.R
```

### Step2: family-level SNP QC
```{sh}
Rscript 7B_1.extractPRSSNP.R
Rscript 7B_2.extractPRSSNP_for_eachTrios.R
sbatch --array=1-22 --wrap="Rscript 7B_3.Recover.extractPRSSNP_for_eachTrios.R"
```

### Step3: Obtain target SNPs from Step4 above
```{sh}
Rscript 7B_4.extractPRSSNP_fromBase.R
```

### Step4: Calculate PRS
Extract Haplotypes and calculate PRS for each (paternal/maternal) allele
```{sh}
Rscript 7B_5.extractHap.R
```

### Step5: Comparison of PRS
Regress out parental PCs and compare paternal and maternal PRS

```{sh}
./7B_7.CalcParentPC.sh
Rscript 7B_8.RegressOutparentPC.R
```
