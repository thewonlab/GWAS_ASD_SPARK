options(stringsAsFactors=F) 
input = commandArgs(trailingOnly=TRUE)[1]
dt = read.table(input,header=F)
colnames(dt) = c("FID","IID","PID","MID","SEX","PHENO")

pheno = read.table("40POO/20190730/model1_Pheno.txt",header=F)
colnames(pheno) = c("FID","IID","PHENO_U")

dtt = merge(dt,pheno,all.x=T,by.x="IID",by.y="IID")
dtt$PHENO = ifelse(dtt$PHENO == -9, dtt$PHENO_U,dtt$PHENO)
write.table(dtt[c("FID.x","IID","PID","MID","SEX","PHENO")],file=input,quote=F,row.names=F,col.names=F,sep="\t")
