options(stringsAsFactors=F)

Diagnosis = read.delim("AA_Phenotype/Individuals.txt",header=T)
Diagnosis = Diagnosis[c(1,2,18,28,29)]
colnames(Diagnosis)[c(1,2)] = c("iid","fid")

fsample = "20GWAS/201905/trio_4/plink/20190423_20190624.psam"
samples = read.table(fsample,header=F)
colnames(samples) = c("fid","iid","pid","mid","sex","asd")

ck_data <- function(dataset,file){
 print(dataset)
 dt = read.table(file,header=F)
 colnames(dt) = c("fid","iid")
 dt = samples[samples$iid %in% dt$iid,]
 dt = dt[grep("-T",dt$iid),]
 dt$iid = gsub("-T","",dt$iid)
 dt$iid = unlist(lapply(strsplit(dt$iid, split="[_]"),'[[',2))
 dt = merge(dt,Diagnosis)
 print("Autism Spectrum Disorder")
 print(round((nrow(dt[dt$sex == 1 & dt$diagnosis == "Autism Spectrum Disorder",])/nrow(dt[dt$diagnosis == "Autism Spectrum Disorder",]))*100,2))
 print("Autism or Autistic Disorder")
 print(round((nrow(dt[dt$sex == 1 & dt$diagnosis == "Autism or Autistic Disorder",])/nrow(dt[dt$diagnosis == "Autism or Autistic Disorder",]))*100,2))
 print("Asperger's")
 print(round((nrow(dt[dt$sex == 1 & dt$diagnosis == "Asperger's Disorder",])/nrow(dt[dt$diagnosis == "Asperger's Disorder",]))*100,2))
 print("PDD-NOS")
 print(round((nrow(dt[dt$sex == 1 & dt$diagnosis == "Pervasive Developmental Disorder - Not Otherwise Specified (PDD-NOS)",])/nrow(dt[dt$diagnosis == "Pervasive Developmental Disorder - Not Otherwise Specified (PDD-NOS)",]))*100,2))

 dt$language_level = as.factor(dt$language_level)
 dt$diagnosis = as.factor(dt$diagnosis)
 dt$sex = as.factor(dt$sex)
 print(summary(dt$diagnosis))
}

ck_data("all QC cleared","20GWAS/201905/trio_4/plink/20190423_20190503v1_model1.final.indiv")
ck_data("EUR only","20GWAS/201905/trio_4/plink/20190423_20190503v1_model1EUR.final_one_from_one_pedigree.indiv")
