# README

This repository contains codes for the paper:

 "Common genetic risk variants identified in the SPARK cohort implicate *DDHD2* as a novel autism risk gene"

Nana Matoba, Dan Liang, Huaigu Sun, Nil Aygün, Jessica C. McAfee, Jessica E. Davis, Laura M. Raffield, Huijun Qian,  Joseph Piven, Yun Li, Sriam Kosuri, Hyejung Won\* and Jason L. Stein\* (\* equally supervised)

## Codes

- [Pre-Imputation](https://github.com/thewonlab/GWAS_ASD_SPARK/tree/master/Pre-Imputation) : pre-imputation process
  - data QC
  - phasing and generating pseudocontrols
- [Post-Imputation](https://github.com/thewonlab/GWAS_ASD_SPARK/tree/master/Post-Imputation) : post-imputation
  - data QC
  - data conversion
- [AssocTests](https://github.com/thewonlab/GWAS_ASD_SPARK/tree/master/AssocTests) : Association tests
  - GWASs
  - Meta-analyses
- [LDSC](https://github.com/thewonlab/GWAS_ASD_SPARK/tree/master/LDSC) : LDSC analysis
  - Estimating SNP-based heritability on liability scale
  - Estimating Heritability enrichment
  - Estimating Genetic Correlation
- [H-MAGMA](https://github.com/thewonlab/GWAS_ASD_SPARK/tree/master/H-MAGMA) : Gene-based test
  - Running H-MAGMA
  - Functional annotation of H-MAGMA genes
- [PRS](https://github.com/thewonlab/GWAS_ASD_SPARK/tree/master/PRS) : Polygenic Risk Score analyses
  - QC
  - Run PRSice-2
  - Regression
  - Group-test (Male vs Female; Multiplex vs Simplex;)
  - Paternal alleles vs Maternal alleles
- [MPRA](https://github.com/thewonlab/GWAS_ASD_SPARK/tree/master/MPRA) : MPRA-analyses generated by Hyejung Won and Huaigu Sun
- [etc](https://github.com/thewonlab/GWAS_ASD_SPARK/tree/master/etc) : Other codes
  - Estimation of heritability on the liability scale (GWAS index SNPs)
  - GWAS catalog Pleiotoropy check
  - Finding TF binding motif
- [ATAC-seq](https://bitbucket.org/steinlabunc/celltypespecificcaqtls/src/master/) generated by Dan Liang
- [eQTL](https://bitbucket.org/steinlabunc/expression-qtl/src/master/) generated by Nil Aygün 

## Publicly available sortware/packages/libraries
We also used publicly avaialable software, please see their websites for details.
- [BBMap](https://sourceforge.net/projects/bbmap/)
- [bc_map](https://github.com_kinsigne/bc_map)
- [BSgenome](https://bioconductor.org/packages/release/bioc/html/BSgenome.html)
- [BSgenome.Hsapiens.UCSC.hg38 (v1.4.1)](https://bioconductor.org/packages/release/data/annotation/html/BSgenome.Hsapiens.UCSC.hg38.html)
- [data.table (v1.11.2)](https://cran.r-project.org/web/packages/data.table/index.html)
- [EAGLE (v2.4.1)](https://data.broadinstitute.org/alkesgroup/Eagle/)
- [fmsb (v0.6.3)](https://cran.r-project.org/web/packages/fmsb/index.html)
- [g:Profiler (v0.6.7)](https://biit.cs.ut.ee/gprofiler/)
- [GenomicRanges](https://bioconductor.org/packages/release/bioc/html/GenomicRanges.html)
- [ggpubr](https://cran.r-project.org/web/packages/ggpubr/index.html)
- [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html)
- [ggrepel](https://cran.r-project.org/web/packages/ggrepel/index.html)
- [H-MAGMA](https://github.com/thewonlab/H-MAGMA)
- [htslib (v1.9)](https://github.com/samtools/htslib)
- [LDSC (v1.0.0)](https://github.com/bulik/ldsc)
- [MAGMA (1.07b)](https://ctg.cncr.nl/software/magma)
- [METAL (release 2018-08-28)](https://genome.sph.umich.edu/wiki/METAL)
- [motifbreakR (v1.14.0)](https://bioconductor.org/packages/release/bioc/html/motifbreakR.html)
- [MotifDb (v1.26.0)](http://bioconductor.org/packages/release/bioc/html/MotifDb.html)
- [mpra](https://github.com/hansenlab/mpra)
- [PLINK1.9](www.cog-genomics.org/plink/1.9/) 
- [PLINK2 (2.00a-20190527)](www.cog-genomics.org/plink/2.0/) 
- [PRSice-2](https://www.prsice.info/)
- [pROC (v1.15.3)](https://cran.r-project.org/web/packages/pROC/index.html)
- [seqLogo (v1.50.0)](https://bioconductor.org/packages/release/bioc/html/seqLogo.html)
- [SNPlocs.Hsapiens.dbSNP144.GRCh38](http://bioconductor.org/packages/release/data/annotation/html/SNPlocs.Hsapiens.dbSNP144.GRCh38.html)
- [snpfEff (4.3T)](http://snpeff.sourceforge.net/)
- [tidyverse (v1.2.1)](https://www.tidyverse.org/)
