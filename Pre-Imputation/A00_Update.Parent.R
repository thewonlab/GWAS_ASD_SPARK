# Some of parents genotype information are not available, update parental id to 0 in .fam file
f_org<-"02_AllIndivs/20190503v1/SPARK.30K.array_genotype.20190423.fam.org"
f_out<-"02_AllIndivs/20190503v1/SPARK.30K.array_genotype.20190423.fam"
f_nogenoid<-"00conf/20190501release.nopid.txt"

org<-read.table(f_org,stringsAsFactors=FALSE,header=F)
nogenoid<-read.table(f_nogenoid,stringsAsFactors=F,header=F)

colnames(org)<-c("sfid","spid","father","mother","sex","asd")
org$flg<-ifelse(org$father %in% nogenoid$V1,"f",ifelse(org$mother %in% nogenoid$V1,"m","OK"))
org$father<-ifelse(org$father %in% nogenoid$V1,0,org$father)
org$mother<-ifelse(org$mother %in% nogenoid$V1,0,org$mother)

write.table(org[-ncol(org)],file=f_out,quote=F,col.names=F,row.names=F,sep=" ")
