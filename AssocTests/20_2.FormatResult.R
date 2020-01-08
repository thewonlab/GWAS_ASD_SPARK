options(stringsAsFactors=F)
library(GenomicRanges)
library(data.table)

path<-"/pine/scr/n/a/nanam/spark/spark-work/20GWAS/201905/trio_4/plink"
sumstats<-paste(path,"/SPARK.auto.assoc.result.rdata",sep="")
GRangefile<-paste(path,"/SPARK.auto.GR.rdata",sep="")

assoc_format<-function(pattern,model) {
 files <- list.files(path=path, pattern=pattern,full.names=TRUE, recursive=TRUE)
 print(head(files))
 for (file in files){
	if (!exists("assoc_model")){
		assoc_model = fread(file, header=FALSE, skip=1, sep="\t",data.table=F) # load file
	} else if (exists("assoc_model")){
		temp_dataset =fread(file, header=FALSE, skip=1, sep="\t",data.table=F)
		assoc_model = rbind(assoc_model, temp_dataset)
	}
  }
 colnames(assoc_model)<-c("CHROM","POS","ID","REF","ALT","A1","A1_FREQ","A1_CASE_FREQ","A1_CTRL_FREQ","TEST","OBS_CT","BETA","LOG_OR_SE","P")

 assoc_model$A2<-ifelse(assoc_model$A1==assoc_model$REF,assoc_model$ALT,assoc_model$REF)
 assoc_model$OR<-exp(assoc_model$BETA)
 write.table(file=paste(path,"/SPARK_update_model",model,sep=""),assoc_model,quote=FALSE,row.names=F,sep="\t")

 model_GR <- GRanges(seqnames=assoc_model$CHROM, IRanges(assoc_model$POS,assoc_model$POS))
 mcols(model_GR)<-assoc_model[,c(1:ncol(assoc_model))]
 return(model_GR)
}

 SPARK_model1QC_GR<-assoc_format("*_model1QC.assoc.PHENO1.glm.logistic$","1QC")
 SPARK_model1QC_EUR_GR<-assoc_format("*_model1QCEUR5SD.assoc.PHENO1.glm.logistic$","1QC_EUR_only")
 save(SPARK_model1QC_GR,SPARK_model1QC_EUR_GR,file=GRangefile)
