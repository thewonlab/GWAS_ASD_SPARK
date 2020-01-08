# README

Please also check and cite
[LDSC]()

### Step1: Format summary statistics for LDSC input

```{sh}
sbatch ./50_1.munge.sh
```

### Step2: Genetic correlation between ASD and various traits

```{sh}
sbatch ./50_2.GeneticCorrelation.sh
```

### Step3: Heritability enrichment analysis
1. Computing heritability for differential accessibility chromatin peak (GZ and CP)  
Statistics for differential accessibility peak was extracted from following paper.  
Luis de la Torre-Ubieta and Jason L.Stein et al., <I>"The Dynamic Landscape of Open Chromatin during Human Cortical Neurogenesis"</I>  
[DOI:10.1016/j.cell.2017.12.014](https://doi.org/10.1016/j.cell.2017.12.014)
```{sh}
Rscript 51_4.mkLDSC_HeritInput_GZCP_noliftOver.R
```
2. Adding annotation to the baseline-LD model
```{sh}
./52_1.wrap.mkAnno.LDSC.sh # this calls mkAnno.LDSC.sh in the script
```
3. Estimate heritability enrichment in differential accessibility chromatin peak
```{sh}
sbatch ./52_2.runLDSC_Enrichment.sh
```

### Step4: Calculate SNP based heritability

```{sh}
sbatch ./53_1.CalcHeritability.sh
```
