library(ggplot2)
options(stringsAsFactors=F)
QC<-read.table("02_AllIndivs/20190503v1/SPARK.30K.array_genotype.20190423_noYMt_QC1_m.imiss",header=T)
FAM<-read.table("01_Trios/20190503v1/SPARK.30K.array_genotype.20190423_noYMt_QC4_Perfecttrios_ASDonly.fam",header=F)
colnames(FAM)<-c("FID","IID","PID","MID","SEX","ASD")

r<-read.table("01_Trios/20190503v1/SPARK.30K.array_genotype.20190423_noYMt_QC4_TrioQCed_pruned.g.genome.gz",header=T)
r<-r[c("FID1","IID1","FID2","IID2","RT","Z0","Z1","PI_HAT")]
r$flg<-ifelse(r$PI_HAT > 0.9, "Identical",ifelse((r$PI_HAT > 0.2 & r$RT!="PO" & r$RT!="FS"), "unexpected relatives","other"))

png(file="98Plots/IBD.png",width=1100,height=1400,res=400)

ggplot(r)+geom_point(aes(x=Z0,y=Z1,color=RT,shape=as.factor(flg)),size=0.8)+scale_color_manual(values=c(1,2,3,4))+scale_shape_manual(values=c(16,8,1))+theme_classic()
dev.off()

nrow(subset(r,flg=="Identical"))
nrow(subset(r,flg=="unexpected relatives"))

rmList_Twins<-subset(r,flg=="Identical")
rmList_UnexpectedRelatives<-subset(r,flg=="unexpected relatives")

for(i in 1:nrow(rmList_Twins)){
 f1<-subset(QC,FID==rmList_Twins[i,1]&IID==rmList_Twins[i,2])$FID
 i1<-subset(QC,FID==rmList_Twins[i,1]&IID==rmList_Twins[i,2])$IID
 f2<-subset(QC,FID==rmList_Twins[i,3]&IID==rmList_Twins[i,4])$FID
 i2<-subset(QC,FID==rmList_Twins[i,3]&IID==rmList_Twins[i,4])$IID

 miss1<-subset(QC,IID==i1)$F_MISS
 miss2<-subset(QC,IID==i2)$F_MISS

 if(miss1 > miss2) {
  rmind<-c(f1,i1)
 } else{
  rmind<-c(f2,i2)
 }

 if(i==1){
  rmindlist<-rmind
 }else{
  rmindlist<-rbind(rmindlist,rmind)
 }

}

write.table(rmindlist,row.names=F,quote=F,col.names=F,file="01_Trios/20190503v1/remove_sample_list_with_IdenticalTwins.txt")

