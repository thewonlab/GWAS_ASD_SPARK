options(stringsAsFactors=F)
library(GenomicRanges)

base = "70PRS/03PRSinput/GWAS/iPSYCHPGC_HG38_update_model1QC_EUR_only_noMHC_MAF005"
prs_base = read.table(base,header=T,sep="\t")
prs_base_GR = GRanges(prs_base$CHR,IRanges(prs_base$BP,prs_base$BP))
mcols(prs_base_GR) = prs_base[,c(3,4,6:9)]

prs_snp = read.table("70PRS/04PRS_WKDIR/prsice/rawPRS_CC_QC/ASD_SPARK_EUR_SPARK.snp",sep="\t",header=T)

prs_snp_GR = GRanges(paste0("chr",prs_snp$CHR),IRanges(prs_snp$BP,prs_snp$BP))
olap = findOverlaps(prs_base_GR,prs_snp_GR)
prs_base_GR = prs_base_GR[queryHits(olap)]

save(prs_base_GR,file="70PRS/03PRSinput/GWAS/iPSYCHPGC_HG38_update_model1QC_EUR_only_noMHC_MAF005.Rdata")

