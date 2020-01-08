#######################################
### Read RNA-seq result files #########
#######################################
options(stringsAsFactors = F)
fastqdir = "/proj/hyejunglab/MPRA/RNAseq/variant1/HEK/batch3/fastq/"
setwd(fastqdir)
library(dplyr); library(reshape2); library(mpra)
samplename="batch3"
repnum = 6
variant = read.table("/proj/hyejunglab/MPRA/bcmapping/Batch3.sczvar/Batch3.400x/variant_statistics.txt", header=T, sep="\t")
batch.1 = read.table("Batch3_1_cDNA_S2_R1_001_1_bcreads.txt", header=T)
batch.2 = read.table("Batch3_1_cDNA_S2_R1_001_2_bcreads.txt", header=T)
batch.3 = read.table("Batch3_2_cDNA_S3_R1_001_1_bcreads.txt", header=T)
batch.4 = read.table("Batch3_2_cDNA_S3_R1_001_2_bcreads.txt", header=T)
batch.5 = read.table("Batch3_3_cDNA_S4_R1_001_1_bcreads.txt", header=T)
batch.6 = read.table("Batch3_3_cDNA_S4_R1_001_2_bcreads.txt", header=T)
batch.dna = read.table("/proj/hyejunglab/MPRA/RNAseq/variant1/HEK/batch3/fastq2combine/Batch3_plasmid_S1_R1_001_bcreads.txt", header=T)

## Make the variant file proper
bclist = strsplit(variant$barcodes, split=",")
names(bclist) = variant$name
bcdat = melt(bclist)
colnames(bcdat) = c("barcode", "variant")
save(bcdat, file=paste0("barcode_",samplename,".rda"))

load(paste0("barcode_",samplename,".rda"))

# Combine DNA and RNA reads together 
batch = left_join(batch.dna, batch.1, by="barcode")
batch = left_join(batch, batch.2, by="barcode")
batch = left_join(batch, batch.3, by="barcode")
batch = left_join(batch, batch.4, by="barcode")
batch = left_join(batch, batch.5, by="barcode")
batch = left_join(batch, batch.6, by="barcode")

colnames(batch) = c("barcode", "dna", "rna1", "rna2", "rna3", "rna4", "rna5", "rna6")

# remove barcodes that have too many NA values
na_count <- apply(batch[,3:8], 1, function(x) sum(is.na(x)))
batch0 = batch[na_count<4,] # batch[!complete.cases(batch),]
batch0 <- batch0 %>% mutate_if(is.numeric, funs(replace(., is.na(.), 0)))
batch = batch0

#######################################
### Clump based on variants ###########
#######################################

# Match barcodes with variants
batch$variant = bcdat[match(batch$barcode, bcdat$barcode), "variant"]
batch = batch[complete.cases(batch),] # this reduces 615078 -> 586008

batchvar = batch %>% group_by(variant) %>% summarise(rna.s1=sum(rna1), rna.s2=sum(rna2), rna.s3=sum(rna3),
                                                     rna.s4=sum(rna4), rna.s5=sum(rna5), rna.s6=sum(rna6),
                                                     dna.s=sum(dna))

batchvar$SNP = unlist(lapply(strsplit(batchvar$variant, split="_"),'[[',2))
batchvar$allele = unlist(lapply(strsplit(batchvar$variant, split="_"),'[[',4))

# Remove variants that do not have risk/protective allelic pairs
snps = table(batchvar$SNP)
snps = names(snps[snps==1])
batchvar = batchvar[!(batchvar$SNP %in% snps),]
  
save(batch, batchvar, file=paste0(samplename,"_RNAseq_sum_counts.rda"))

#######################################
### Generate MPRASet ##################
#######################################
# Make sure that all variants are paired in the batchvar in order
theindex = c()
for(i in 1:(nrow(batchvar)/2)){
  newi = i*2
  if(batchvar$SNP[newi]!=batchvar$SNP[newi-1]){
    theindex = c(theindex, newi)
  }
}

# dna matrix
dnamat = matrix(unlist(lapply(batchvar$dna.s, function(x){rep(x,repnum)})), ncol=(2*repnum), byrow=T)
rownames(dnamat) = unique(batchvar$SNP)
colnames(dnamat) = c(paste(rep("alt",repnum),paste0("s",1:repnum),sep="_"), paste(rep("ref",repnum),paste0("s",1:repnum),sep="_"))

# rna matrix
rnamat = merge(batchvar[seq(1,nrow(batchvar)-1,2),c(2:7,9)], batchvar[seq(2,nrow(batchvar),2),c(2:7,9)],by='SNP',all=TRUE)
rownames(rnamat) = rnamat$SNP
rnamat = rnamat[,-1]
colnames(rnamat) = c(paste(rep("alt",repnum),paste0("s",1:repnum),sep="_"), paste(rep("ref",repnum),paste0("s",1:repnum),sep="_"))

# variant IDs (rsIDs)
varid = rownames(dnamat)

# variant sequences
variant = variant[,1:2]
variant$rsid = unlist(lapply(strsplit(variant$name,split="_"),'[[',2))
varseq = variant[match(varid, variant$rsid), "variant"]

# generate an mpraset (input file for mpralm)
mpraset = MPRASet(DNA=dnamat, RNA=rnamat, eid=varid, eseq=varseq, barcode=NULL)

#######################################
### Run mpralm ########################
#######################################
# design matrix (Ref vs. Alt)
designmat = data.frame(intcpt=rep(1,repnum*2), 
                       alt=c(rep(TRUE,repnum),rep(FALSE,repnum)))

# sample info
samples = rep(1:6,2)

# analyze
mpraresult = mpralm(object=mpraset, 
                    design=designmat, 
                    plot=T,
                    aggregate="none",
                    normalize=T, 
                    block=samples,
                    model_type="corr_groups")

# mpraresult in a table
mpradat = topTable(mpraresult, coef = 2, number = Inf)

# save the results
save(mpraresult, mpradat, dnamat, rnamat, varid, varseq, file="mpralm.rda")

# significant results 
mprasig = mpradat[mpradat$adj.P.Val<0.05,]
