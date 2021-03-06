# README

This directory contains codes for association tests

### Step1: Association test for case vs pseudo-controls in SPARK dataset
This script includes ([PLINK2.0](https://www.cog-genomics.org/plink/2.0/)) based association test for SPARK full dataset GWAS as well as ancestry-stratified GWAS  
This will be done for each chromosome 

```{sh}
sbatch --array 1-22 ./20_1.Imputed.Association.test_byPlink.sh
```

### Step2: Format summary statistics

```{sh}
Rscript 20_2.FormatResult.R
```

### Step3: Matching SNPs
Compare SNPs between SPARK summary statistics and iPSYCH-PGC data  
iPSYCH-PGC summary statistics was obtained from ..  
[PGC website (ASD iPSYCH – PGC GWAS – 2017 (publ. 2019)](https://www.med.unc.edu/pgc/results-and-downloads/asd/?choice=Autism+Spectrum+Disorder+%28ASD%29) generated by Grove et al.  
*"Identification of common genetic risk variants for autism spectrum disorder"*  [doi:10.1038/s41588-019-0344-8](https://doi.org/10.1038/s41588-019-0344-8)

```{sh}
Rscript AE00_1.MergeSumstats_withSPARK_forMeta.R
```

### Step4: Perform meta-analysis by [METAL](https://genome.sph.umich.edu/wiki/METAL)

```{sh}
./AE00_2.Metal.sh
```
