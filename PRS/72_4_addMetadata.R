rm(list=ls())
options(stringsAsFactors = FALSE)

setwd("70PRS/04PRS_WKDIR/prsice/")

setwd("rawPRS_CC_QC/")

asd_prs = read.table("ASD_SPARK_EUR_SPARK.all.score",header=T)
asd_prs = asd_prs[,c(2:12)]
colnames(asd_prs) = c("ID","T1","T2","T3","T4","T5","T6","T7","T8","T9","T10")

asd_fam = read.table("../../../01geno/ALL_CC/chr1.psam",col.names=c("FID","ID","Sex","Diagnosis","FamilyType"))
asd_pca = read.table("../../../02genoQC/ALL_CC/auto_pruned_PCA_CaseOnly.eigenvec",col.names=c("FID","ID","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10"))
asd_meta = merge(asd_fam[,c(2:5)],asd_pca[,c(2:12)],all.x=T)

#Family type 1<->2
Familytype = ifelse(asd_meta$FamilyType == 1, 2, ifelse(asd_meta$FamilyType == 2,1,asd_meta$FamilyType))
asd_meta$FamilyType = Familytype

asd_meta[,2] = asd_meta[,2]-1
asd_meta[,3] = asd_meta[,3]-1

setwd("../")

meta = asd_meta
dx=meta$Diagnosis

save(dx,meta,asd_prs,file="1_meta_nonreg_data.QC.RData")
