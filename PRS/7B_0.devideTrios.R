options(stringsAsFactors=F)
samples=read.table("41EMIM/dataset/model1_eur_cases.parent",header=F)
colnames(samples) = c("Fam","IID","PID","MID","SEX","ASD")
proband = samples[grep("-T",samples$IID),]
families = unique(proband$Fam)
print(length(families))
for(i in 1:length(families)){
 proband[proband$Fam==families[i],]
 dir=paste0("70PRS/10POOPRS/Target/Fam/",i,"/")
# dir.create(dir)
 print(i)
 pid=proband[proband$Fam==families[i],c(1,2)]
 patid=proband[proband$Fam==families[i],c(1,3)]
 matid=proband[proband$Fam==families[i],c(1,4)]
 write.table(file=paste0(dir,"members.txt"),x=pid,quote=F,col.names=F,row.names=F)
 write.table(file=paste0(dir,"members.txt"),x=patid,quote=F,col.names=F,row.names=F,append=T)
 write.table(file=paste0(dir,"members.txt"),x=matid,quote=F,col.names=F,row.names=F,append=T)
}
