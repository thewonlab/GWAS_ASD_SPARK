options(stringsAsFactors=F)

one = read.table("20GWAS/201905/trio_4/plink/20190423_20190503v1_model1.final.cases_oneindiv_from_pedigree",header=F)
poo = read.table("40POO/20190730/chr1.imputed_model1.fam",header=F)

poo$IID = poo$V2
poo = within(poo, IID<-data.frame(do.call('rbind', strsplit(as.character(IID), '_', fixed=TRUE))))

poo$IID = gsub("-T","",poo$IID$X2)

poo_final = poo[poo$IID %in% one$V2 | (poo$V3==0 & poo$V4==0),]

eur = read.table("20GWAS/201905/trio_4/plink/20190423_20190503v1_model1EUR5SD.final.indiv",header=F)
poo_eur = poo_final[poo_final$V1 %in% eur$V1,]
write.table(poo_eur[c("V1","V2","V3","V4","V5","V6")],file="41EMIM/dataset/model1_eur_cases.parent",quote=F,row.names=F,col.names=F)
