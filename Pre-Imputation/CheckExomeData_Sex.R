library(ggplot2)
library(ggrepel)
require("ggrepel")


input_WES <- commandArgs(trailingOnly=TRUE)[1]
input_Array <- commandArgs(trailingOnly=TRUE)[2]
removeSamples <- commandArgs(trailingOnly=TRUE)[3]

wes<-read.delim(input_WES, header=T, stringsAsFactors = F,fill=T,sep="\t")
colnames(wes)[c(1:11)]<-c("INDV","X_Loci","X_MEAN_DEPTH","Auto_Loci","Auto_MEAN_DEPTH","SFID","SPID","FA","MO","SEX","PHENO")

array<-read.table(input_Array, header = T,stringsAsFactors = F,fill=T)

wes_array<-merge(wes,array,by.x="SPID",by.y="IID")

wes_array$normalizedX<-wes_array$X_MEAN_DEPTH/wes_array$Auto_MEAN_DEPTH
wes_array$SEXCHECK<-paste(wes_array$SEX,wes_array$STATUS)
wes_array$SEX<-as.character(wes_array$SEX)

png("98Plots/SexCheck_WES_201905.png",width=800,height=800)

p<-ggplot(wes_array)+geom_point(aes(x=normalizedX,y=F,color=as.character(SEXCHECK),shape=as.character(SEXCHECK)))
p<-p+scale_shape_manual(name="SEX Mismatch Flag",values = c(16,4,16,4),labels=c("Male-OK","Male-NG","Female-OK","Female-NG"))
p<-p+geom_hline(yintercept = c(0.2,0.8),linetype="dotted",color=c("red","blue"))
p<-p+geom_label_repel(data=subset(wes_array,normalizedX>1.25),aes(x=normalizedX,y=F,label=SPID),color="pink",size=4)
p<-p+geom_label_repel(data=subset(wes_array,normalizedX<0.75 & SEX=="2"),aes(x=normalizedX,y=F,label=SPID),color="red",size=4)
p<-p+geom_label_repel(data=subset(wes_array,normalizedX>0.75 & SEX=="1" & STATUS=="OK"),aes(x=normalizedX,y=F,label=SPID),color="skyblue",size=4)
p<-p+geom_label_repel(data=subset(wes_array,normalizedX>0.75 & SEX=="1" & STATUS=="PROBLEM"),aes(x=normalizedX,y=F,label=SPID),color="blue",size=4)
p<-p+scale_color_manual(name="SEX Mismatch Flag",values = c("skyblue","blue","pink","red"),labels=c("Male-OK","Male-NG","Female-OK","Female-NG"))
p<-p+scale_y_continuous(limits = c(-0.5,1),breaks=seq(-1,1,by=0.1))+theme_bw()+xlab("Normalized Depth (X)")

p
dev.off()
error<-subset(wes_array,(normalizedX>0.75 & SEX=="1" & STATUS=="PROBLEM"|normalizedX<0.75 & SEX=="2"))
nrow(error)
write.table(error[c("SFID","SPID")],file=removeSamples,quote=F,row.names=F,col.names=F,sep=" ")

