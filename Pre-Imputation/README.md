# README

This directory contains codes for QC before Imputations

### Step1: Update Parent ID
Some of parents genotype information are not available, update parental id to 0 in .fam file
```{sh}
Rscript A00_Update.Parent.R
```

### Step2: SNP QC
Select autosomes, X-chromosomes only, and remove SNPs w/ low genotyping rate ( < 0.9)
```{sh}
sbatch ./A01_SNPQC.sh
```

### Step3: Sample QC
1. Remove individuals with high missingness ( > 0.1)
```{sh}
sbatch ./A02_HighMissingness.sh
```
2. Sex Check
```{sh}
sbatch ./A03_SexCK.1.sh
sbatch ./A03_SexCK.2.sh
sbatch --wrap "./CheckExomeData_Sex.sh ${indivID} ${gvcf} ${outputdir}"
Rscript CheckExomeData_Sex.R
```
3. Sample swap and Contamination Check
```{sh}
sbatch ./A04_VerifyBamID.1.sh
sbatch --array=0-9 ./A04_VerifyBamID.2.sh
```
### Step4: Remove poor quality SNPs and Samples
```{sh}
sbatch ./A05_PoorSNPsSamples.sh
```

### Step5: Mendel Error Check
```{sh}
sbatch ./A06_MendelError.sh
```

### Step6: Check family information
```{sh}
sbatch ./A07_UpdatePheno.sh
sbatch ./A08_Fam_Check.sh
Rscript A09_CheckRelatedness.R
sbatch ./A10_Fam_Check.2.sh
./A10_Fam_Check.3.sh
```

### Step7: MDS plot
includes defining ancestries (EUR, AFR, EAS)
```{sh}
sbatch ./A11_getTagSNPs_FinalTrios.sh
sbatch ./A12_MargeSNPs_HM3_FinalTrios.sh
sbatch ./A13_MDS_Trios.sh
./A14_MDS_convert.sh 01_Trios/20190503v1/SPARK.30K.array_genotype.20190423_noYMt_QC4_HM3mds.mds
Rscript ./A15_PlotMDS_density.R 01_Trios/20190503v1/SPARK.30K.array_genotype.20190423_noYMt_QC4_HM3mds.mds.tsv
```

### Step8: Generate pseudocontrols and Phase Genotypes
```{sh}
rake -f Rakefile_Phasing CONF=configure.20190530.yaml prephasing:STEP1_SNPQC --trace
rake -f Rakefile_Phasing CONF=configure.20190530.yaml prephasing:STEP2_ChunkForAutoChrs --trace
rake -f Rakefile_Phasing CONF=configure.20190530.yaml prephasing:STEP3_bed2BCF --trace
rake -f Rakefile_Phasing CONF=configure.20190530.yaml preptrio:STEP1_preppheno --trace
rake -f Rakefile_Phasing CONF=configure.20190530.yaml preptrio:STEP2_CombineGenotypes --trace
rake -f Rakefile_Phasing CONF=configure.20190530.yaml preptrio:STEP2_MkPseudoCtrl --trace
rake -f Rakefile_Phasing CONF=configure.20190530.yaml preptrio:STEP2_PickupParents --trace
rake -f Rakefile_Phasing CONF=configure.20190530.yaml preptrio:STEP3_convert2BCF --trace
rake -f Rakefile_Phasing CONF=configure.20190530.yaml phasing:Phasing --trace
```

