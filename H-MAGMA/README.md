# README

This directory contains codes to run H-MAGMA and functional annotation for H-MAGMA genes

Please also check papers and github listed below for details

- Sey et al., 2019 bioRxiv, doi: https://doi.org/10.1101/681353 
"Connecting gene regulatory relationships to neurobiological mechanisms of brain disorders"
- github:[H-MAGMA](http://github.com/thewonlab/H-MAGMA)
- Matoba et al., 2020 *"Mapping Alzheimer's Disease Variants to Their Target Genes Using Computational Analysis of Chromatin Configuration."*  
 [doi:10.3791/60428](https://www.jove.com/video/60428/mapping-alzheimer-s-disease-variants-to-their-target-genes-using)


### Step1: run MAGMA using H-MAGMA input
- MAGMA input files were obtained from [H-MAGMA website](http://github.com/thewonlab/H-MAGMA/tree/master/Input_Files)
```{sh}
sbatch ./60_1.runHMAGMA.sh
```

### Step2: Annotate H-MAGMA Genes (ENSG->hgnc_symbol)
```{sh}
Rscript 60_2.MappingGenes_fromHMAGMA.R
```

### Step3: Gene ontology analysis using g:Profiler
```{sh}
Rscript 60_3.GOanalysis_HMAGMA.R
```

### Step4: Developmental expression pattern of ASD risk genes (H-MAGMA genes)
Transcriptome data from embryonic brains and adult brain at 15 developemntal epochs was otained from ..  
Kang et al., *"Spatio-temporal transcriptome of the human brain"*  
[doi:10.1038/nature10523](https://doi.org/10.1038/nature10523); dbGap Accession phs000406.v1.p1

```{sh}
Rscript 60_5.development.R
```
### Step5: H-MAGMA Gene lists that overlap other datasets
- Genes hit by rare variants were obtained from ..  
Satterstrom et al., *"Large-scale exome sequencing study implicates both developmental and functional changes in the neurobiology of autism"*  
[doi:10.1101/484113](https://doi.org/10.1101/484113)
- Differentially expressed genes from ASD post-mortern cortex compared to neurotypical controls were obtained from ..  
Parikshak et al., *"Genome-wide changes in lncRNA, splicing, and regional gene expression patterns in autism"*  
[doi:10.1038/s41586-018-0295-8](https://doi.org/10.1038/s41586-018-0295-8)
```{sh}
Rscript 60_6.GeneOverlap.R
```
