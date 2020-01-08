##module add r/3.6.0
# code is addapted from Dan Liang
#if (!requireNamespace("BiocManager", quietly = TRUE))
    #install.packages("BiocManager")
#BiocManager::install("motifbreakR")
#BiocManager::install("SNPlocs.Hsapiens.dbSNP144.GRCh38")
#BiocManager::install("BSgenome.Hsapiens.UCSC.hg38")
library(motifbreakR);
library(BSgenome);
library(SNPlocs.Hsapiens.dbSNP144.GRCh38); 
library(BSgenome.Hsapiens.UCSC.hg38);
library(MotifDb);
options(stringsAsFactors=FALSE);
args = commandArgs(TRUE);
SNPlist= "rs7001340"

## extract SNPs info
snps.mb <- snps.from.rsid(rsid = as.character(SNPlist),dbSNP = SNPlocs.Hsapiens.dbSNP144.GRCh38,search.genome = BSgenome.Hsapiens.UCSC.hg38);
head(snps.mb)
## load human MotifDb
testMotifDb=MotifDb[which(mcols(MotifDb)$organism=="Hsapiens")];
## remove stamlab Motifs, because they are not annotated 
testMotifDb=testMotifDb[which(mcols(testMotifDb)$dataSource!="stamlab")];
results=GRanges();

i=as.numeric(args[1]);

thisresults <- motifbreakR(snpList = snps.mb[1], filterp = TRUE,pwmList = testMotifDb,threshold = 1e-4,method = "ic",bkg = c(A=0.25, C=0.25, G=0.25, T=0.25),BPPARAM = BiocParallel::bpparam());

thisresults = calculatePvalue(thisresults)
save(thisresults,file="21FUNCTION/04Motif/motifbreakR_results2.Rdata")

library(seqLogo)
pdf("98Plots/Motif/rs7001340.pdf",useDingbats=FALSE)
tbx1 = testMotifDb$"Hsapiens-jolma2013-TBX1"
tbx1 = tbx1[c(4,3,2,1),]
tbx1 = data.frame(tbx1)
seqLogo(tbx1)
smrc1 = testMotifDb$"Hsapiens-HOCOMOCOv10-SMRC1_HUMAN.H10MO.D"
smrc1 = smrc1[c(4,3,2,1),]
smrc1 = data.frame(smrc1)
seqLogo(smrc1)
dev.off()
