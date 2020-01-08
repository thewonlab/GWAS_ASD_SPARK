# README

### Step1: Annotate SNP with rsID 
It requires dbsnp vcf file([00-All.vcf.gz](ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/)) and index file.
In the paper, we used dbsnp151.
```{sh}
wget -c ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/00-All.vcf.gz
wget -c ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/00-All.vcf.gz.tbi
sbatch --array=1-22 ./00_1.dbsnp.anno.sh
```

### Step2: Convert vcf to plink .pgen format
```{sh}
sbatch --array=1-22 ./00_2.ConvertPlink.sh
```
### Step3: Assessment imputation quality using WES data
```{sh}
sbatch --array=1-22 ./10_3.PrepareforAssessmentImputationQuality_All.sh
sbatch --array=1-22 ./10_4.AssessmentImputationQuality_All2.sh
```
