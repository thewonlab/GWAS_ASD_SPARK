options(stringsAsFactors=F)
library(GenomicRanges)
library(gwascat)
#SPARK
load("/pine/scr/n/a/nanam/spark/spark-work/20GWAS/201905/trio_4/plink/SPARK.auto.GR.rdata")
#iPSYCHPGC
load("25GWASData/ASD_BenNeale/iPSYCHPGC_lifover_to_HG38.rdata")
metapath="30Meta/201905/trio_5/"

fOverlap<-function(GRdata,modeln){
 olap = findOverlaps(GRdata,iPSYCHPGC_GR38)
 iPSYCHPGC_vec = 1:nrow(iPSYCHPGC_df38_final)
 nolap = setdiff(iPSYCHPGC_vec, subjectHits(olap))
 nolap_iPSYCHPGC_df38_final = iPSYCHPGC_df38_final[nolap,]
 olapGWAS = GRdata[queryHits(olap)]
 mcols(olapGWAS) = cbind(mcols(olapGWAS), mcols(iPSYCHPGC_GR38[subjectHits(olap)]))
 
 olapGWAS_bk<-olapGWAS
 olapGWAS<-data.frame(olapGWAS)
 
 olapGWAS = subset(olapGWAS,(A1==A1.1&A2==A2.1)| (A1==A2.1&A2==A1.1))
 olapGWAS$flg <- ifelse(olapGWAS$A1==olapGWAS$A1.1&olapGWAS$A2==olapGWAS$A2.1, 1, -1)
 iPSYCHPGC_HG38_update<-olapGWAS[c("ID","CHR","POS","A1.1","A2.1","OR.1","SE","P.1","flg")]
 iPSYCHPGC_HG38_update$N<-olapGWAS$Nca + olapGWAS$Nco
 nolap_iPSYCHPGC_df38_final$N<-nolap_iPSYCHPGC_df38_final$Nca + nolap_iPSYCHPGC_df38_final$Nco
 iPSYCHPGC_HG38_update$A1 <- ifelse(iPSYCHPGC_HG38_update$flg==-1, iPSYCHPGC_HG38_update$A2.1, iPSYCHPGC_HG38_update$A1.1)
 iPSYCHPGC_HG38_update$A2 <- ifelse(iPSYCHPGC_HG38_update$flg==-1, iPSYCHPGC_HG38_update$A1.1, iPSYCHPGC_HG38_update$A2.1)

 colnames(iPSYCHPGC_HG38_update)[c(6,8)]<-c("OR","P")
 iPSYCHPGC_HG38_update$BETA<-log(iPSYCHPGC_HG38_update$OR)
 iPSYCHPGC_HG38_update$BETA <- iPSYCHPGC_HG38_update$flg*iPSYCHPGC_HG38_update$BETA
 iPSYCHPGC_HG38_update<-iPSYCHPGC_HG38_update[c("ID","CHR","POS","A1","A2","OR","SE","P","BETA","N","flg")]
 iPSYCHPGC_HG38_update$CHR<-gsub("chr","",iPSYCHPGC_HG38_update$CHR)

 write.table(file=paste(metapath,"iPSYCHPGC_HG38_update","_",modeln,sep=""),iPSYCHPGC_HG38_update,quote=FALSE,row.names=F,sep = "\t")
}
fOverlap(SPARK_model1QC_GR,"model1QC")
fOverlap(SPARK_model1QC_EUR_GR,"model1QC_EUR_only")
