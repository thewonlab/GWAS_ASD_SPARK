options(stringsAsFactors=F)
library(GenomicRanges)
outputdir = "50LDSC/dataset/GZ_CP_diff_NMatched"
GZCP_peak = read.csv("21FUNCTION/03ChromAccess/Luis_Jason_etal_cell_2018.csv")

GZCP_GR = GRanges(GZCP_peak$Chr,IRanges(GZCP_peak$peakstart,GZCP_peak$peakend))
mcols(GZCP_GR) = GZCP_peak[,5:ncol(GZCP_peak)]
#GZCP_GR = renameSeqlevels(GZCP_GR,newseqlevelnames)
GZ = GZCP_GR[GZCP_GR$log2FoldChange > 0 & GZCP_GR$padj < 0.05,]
CP = GZCP_GR[GZCP_GR$log2FoldChange < 0 & GZCP_GR$padj < 0.05,]

nrow(data.frame(GZ))
#[1] 19260
nrow(data.frame(CP))
#[1] 17803

if(nrow(data.frame(GZ)) > nrow(data.frame(CP))){
 GZ = GZ[sample(1:nrow(data.frame(GZ)),nrow(data.frame(CP))),]
} else {
 CP = CP[sample(1:nrow(data.frame(CP)),nrow(data.frame(GZ))),]
}

save(GZ,CP,file="50LDSC/dataset/GZ_CP_diff_NMatched/DiffPeak.rda")

##Concatenate all categories of interest into a Genomic Ranges List
categories = GRangesList(GZ,CP)
names(categories) = c("GZ","CP")

###Loop over chromosomes
for (i in 1:22) {
   ##Read in locations of SNPs from the annotation files
   snps.table = read.table(gzfile(paste0("/proj/hyejunglab/program/ldsc/LDSC/baselineLD_v1.1/baselineLD.",i,".annot.gz")),header=T)
   
   snps = GRanges(snps.table$CHR,IRanges(snps.table$BP,snps.table$BP),SNP=snps.table$SNP,CM=snps.table$CM)
   ##Loop over categories
   indicator = matrix(0,length(snps),length(categories))
   for (j in 1:length(categories)) {
       ##Find the snps that overlap with the category
       category = categories[[j]]
       olap.cat = findOverlaps(snps,category)
       indicator[queryHits(olap.cat),j] = 1
       ##Write out the new annotation file        
       snps.cat = snps
       mcols(snps.cat) = cbind(as.data.frame(mcols(snps)),indicator)
   }    
    outframe = data.frame(CHR=as.character(seqnames(snps.cat)),BP=start(snps.cat),SNP=mcols(snps.cat)$SNP,CM=mcols(snps.cat)$CM)
    outframe = cbind(outframe,as.data.frame(mcols(snps.cat))[,3:(length(categories)+2)])
    colnames(outframe)[5:ncol(outframe)] = names(categories)

    gz1 = gzfile(paste0(outputdir,"/",i,".annot.gz"), "w")
    write.table(outframe,gz1,quote=FALSE,col.names=TRUE,row.names=FALSE,sep="\t");
    close(gz1)
    print(i)
}

