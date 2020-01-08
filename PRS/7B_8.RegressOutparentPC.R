options(stringsAsFactors = FALSE)
library(data.table)
library(ggpubr)
library(reshape2)

skip=1

if(skip==0){
 pc = fread("70PRS/10POOPRS/PC/auto_pruned_PCA_ParentOnly.eigenvec",data.table=F,header=F)
 
 colnames(pc) = c("FID","IID",sprintf("PC%d",c(1:10)))
 
 sampleinfo = read.table("70PRS/10POOPRS/Target/Fam/1/members.txt",header=F,col.names=c("FID","IID"))
 prs = read.delim("70PRS/10POOPRS/Result/PRS.Score.tsv",header=F,col.names=c("Fam","PPRS","MPRS"))
 
 for(n in 1:4079){
  rd = read.table(paste0("70PRS/10POOPRS/Target/Fam/",n,"/members.txt"),header=F,col.names=c("FID","IID"))
  df = data.frame("FID" = c(rd[2,1],rd[3,1]),"IID" = c(rd[2,2],rd[3,2]),"PRS" = c(prs[n,2],prs[n,3]),"origin"=c("Paternal","Maternal"))
  pc_p = pc[pc$IID == rd[2,2],]
  pc_m = pc[pc$IID == rd[3,2],]
  pc2 = rbind(pc_p,pc_m)
  df = merge(df,pc2)
  print(df)
  if(n==1){
   write.table(x=df,file="70PRS/10POOPRS/Result/PRS.Score_w_FamID.tsv",row.names=F,quote=F,sep="\t")
  } else {
   write.table(x=df,file="70PRS/10POOPRS/Result/PRS.Score_w_FamID.tsv",row.names=F,quote=F,sep="\t",col.names=F,append=T)
  }
 }
} else{
 score = fread("70PRS/10POOPRS/Result/PRS.Score_w_FamID.tsv",header=T)
 tmp=summary(lm(score$PRS ~ data.matrix(score[,c(5:14)])))
 score$PRS_adj = score$PRS - tmp$coefficients[2,1]*score$PC1 -tmp$coefficients[3,1]*score$PC2 -tmp$coefficients[4,1]*score$PC3 -tmp$coefficients[5,1]*score$PC4 -tmp$coefficients[6,1]*score$PC5 -tmp$coefficients[7,1]*score$PC6 -tmp$coefficients[8,1]*score$PC7 -tmp$coefficients[9,1]*score$PC8 -tmp$coefficients[10,1]*score$PC9 -tmp$coefficients[11,1]*score$PC10
 write.table(x=score,file="70PRS/10POOPRS/Result/PRS.Score_w_FamID_regressed.tsv",row.names=F,quote=F,sep="\t")
 pdf(file="70PRS/10POOPRS/plots/ASD_SPARK_POO_20191211.pdf",useDingbats=FALSE)
 
 p = ggviolin(score, x = "origin", y = "PRS_adj", color="origin", palette = "jco",add="boxplot",alpha=0.5,order=c("Paternal","Maternal"))
 p = p+ stat_compare_means(aes(label = paste0("p=",round(..p..,3))), 
                         label.x = 1.5, label.y = 0.15,paired=TRUE)
                         #label.x = 1.5, label.y = 0.15,paired=FALSE)
 p
 dev.off()
}
