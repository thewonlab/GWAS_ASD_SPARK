options(stringsAsFactors=F)

library(GenomicRanges)
for(i in 1:4097){
 dir = paste0("70PRS/10POOPRS/Target/Fam/",i,"/")
 cmd = paste0("cat ",dir,"chr*.haps > ", dir,"All.haps")
 system(cmd)
}

fam = Sys.getenv('SLURM_ARRAY_TASK_ID')

dir = paste0("70PRS/10POOPRS/Target/Fam/",fam,"/")
PRSresult = paste0("70PRS/10POOPRS/Result/",fam,"_PRS.tsv")
hapres = read.table(paste0(dir,"All.haps"),header=F)
hapsample = read.table(paste0(dir,"chr1.sample"),skip=2,col.names=c("FID","ID","missing","sex","PHENO"))

hom_het = c("HomR","HomA")
colnames(hapres)[c(1:5)] = c("CHR","SNP","BP","Ref","Alt")

load("70PRS/03PRSinput/GWAS/iPSYCHPGC_HG38_update_model1QC_EUR_only_noMHC_MAF005.Rdata")

count=1
members = read.table(paste0(dir,"members.txt"))

hapsample$role = ifelse(hapsample$ID %in% members[1,2],"child",ifelse(hapsample$ID %in% members[2,2],"paternal","maternal"))

hapsample$n = 1:nrow(hapsample)

ccoln = c(5 + 2*(hapsample[hapsample$role=="child","n"])-1,5 + 2*(hapsample[hapsample$role=="child","n"]))
pcoln = c(5 + 2*(hapsample[hapsample$role=="paternal","n"])-1,5 + 2*(hapsample[hapsample$role=="paternal","n"]))
mcoln = c(5 + 2*(hapsample[hapsample$role=="maternal","n"])-1,5 + 2*(hapsample[hapsample$role=="maternal","n"]))

fam_genoinfo = hapres[,c(1:5,ccoln,pcoln,mcoln),]
colnames(fam_genoinfo) = c("CHR","SNP","BP","Ref","Alt","P1","P2","F1","F2","M1","M2")
fam_genoinfo$pi = "-"
fam_genoinfo$mi = "-"
fam_genoinfo$phap = "-"
fam_genoinfo$mhap = "-"

for(genotype in c(0:1)){
 fam_genoinfo[fam_genoinfo$F1 == genotype & fam_genoinfo$F1 == fam_genoinfo$F2,"phap"] = hom_het[genotype+1]
 fam_genoinfo[fam_genoinfo$M1 == genotype & fam_genoinfo$M1 == fam_genoinfo$M2,"mhap"] = hom_het[genotype+1]
 }

fam_genoinfo_Homo = fam_genoinfo[fam_genoinfo$P1 == fam_genoinfo$P2,]
fam_genoinfo_Homo[fam_genoinfo_Homo$P1 == 1 ,c("mi","pi")] = 1
fam_genoinfo_Homo[fam_genoinfo_Homo$P1 == 0 ,c("mi","pi")] = 0
fam_genoinfo_Homo[fam_genoinfo_Homo$mi=="-",]
fam_genoinfo_Homo[fam_genoinfo_Homo$pi=="-",]

fam_genoinfo_Hetero = fam_genoinfo[fam_genoinfo$P1 != fam_genoinfo$P2,]
for(genotype in c(0:1)){
 fam_genoinfo_Hetero[(fam_genoinfo_Hetero$P1 == genotype | fam_genoinfo_Hetero$P2 == genotype)  & fam_genoinfo_Hetero$phap == hom_het[genotype+1], "pi"] = genotype
 fam_genoinfo_Hetero[(fam_genoinfo_Hetero$P1 == genotype | fam_genoinfo_Hetero$P2 == genotype)  & fam_genoinfo_Hetero$mhap == hom_het[genotype+1], "mi"] = genotype
 fam_genoinfo_Hetero[fam_genoinfo_Hetero$pi == "-" & fam_genoinfo_Hetero$mi == genotype,"pi"] = abs(1-genotype)
 fam_genoinfo_Hetero[fam_genoinfo_Hetero$mi == "-" & fam_genoinfo_Hetero$pi == genotype,"mi"] = abs(1-genotype)
}

fam_genoinfo_final = rbind(fam_genoinfo_Hetero[c(1:13)],fam_genoinfo_Homo[c(1:13)])
print(nrow(fam_genoinfo_final))
print(nrow(fam_genoinfo_final[fam_genoinfo_final$mi=="-" ,]))
fam_genoinfo_final = fam_genoinfo_final[fam_genoinfo_final$mi!="-" ,]
fam_genoinfo_final$pi = as.numeric(fam_genoinfo_final$pi)
fam_genoinfo_final$mi = as.numeric(fam_genoinfo_final$mi)
fam_genoinfo_final_GR = GRanges(paste0("chr",fam_genoinfo_final$CHR),IRanges(fam_genoinfo_final$BP,fam_genoinfo_final$BP))
mcols(fam_genoinfo_final_GR) = fam_genoinfo_final[,c(2,4,5,6:ncol(fam_genoinfo_final))]

#get risk score (OR) for each SNP
olap = findOverlaps(prs_base_GR,fam_genoinfo_final_GR)
olap_prs = prs_base_GR[queryHits(olap)]
mcols(olap_prs) = cbind(mcols(olap_prs),mcols(fam_genoinfo_final_GR[subjectHits(olap)]))
 
#PRS calculation
df = data.frame(olap_prs)
df$pi_test=ifelse(df$A1 == df$Ref,abs(1-df$pi),df$pi)
df$mi_test=ifelse(df$A1 == df$Ref,abs(1-df$mi),df$mi)

df$pi_score = (df$OR * df$pi_test)/nrow(df)
df$mi_score = (df$OR * df$mi_test)/nrow(df)
prs_p = sum(df$pi_score)
prs_m = sum(df$mi_score)
write.table(as.list((c(fam,prs_p,prs_m))),file=PRSresult,row.names=F,col.names=F,quote=F,append=T,sep="\t")
