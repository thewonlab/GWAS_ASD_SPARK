options(stringsAsFactors = FALSE)
library(GenomicRanges)
library(biomaRt); library(reshape);  library(ggplot2); 

load("/proj/hyejunglab/expression/kangetal/Kang_16874genes_1340samples_HJ.rda")
load(file="60HMAGMA/FDR0.1_AB_FB_GenesList.rda")

diseasename = list("ASD")
diseasegene_all = ASD_SPARK_AB_FB_unique$GENE

load("/proj/hyejunglab/chr/geneAnno_allgenes.rda")

ProteinCoding = subset(geneAnno1,gene_biotype=="protein_coding")
MHCrange = GRanges(seqnames=6, IRanges(25000000,35000000))
ProteinCodingRanges = GRanges(seqnames=ProteinCoding$chromosome_name,IRanges(ProteinCoding$start_position,ProteinCoding$end_position))
olap = findOverlaps(ProteinCodingRanges, MHCrange)
ProteinCoding=ProteinCoding[-queryHits(olap),]

print(length(ProteinCoding[ProteinCoding$ensembl_gene_id %in% diseasegene_all,"ensembl_gene_id"]))
diseasegene = list(ProteinCoding[ProteinCoding$ensembl_gene_id %in% diseasegene_all,"ensembl_gene_id"])

datExpr = scale(datExpr,center = T, scale=FALSE) + 1

exprdat = vector(mode="list", length=length(diseasegene))
for(i in 1:length(diseasegene)){
  exprdat[[i]] = apply(datExpr[match(diseasegene[[i]], rownames(datExpr)),],2,mean,na.rm=T)
}
print(length(diseasegene))

dat = c()
for(i in 1:length(diseasegene)){
  datframe = data.frame(Group=diseasename[[i]], Region=datMeta$Region, Age=datMeta$Age_unit, Unit=datMeta$Unit, Expr=exprdat[[i]])
  dat = rbind(dat, datframe)
}

cortex = c("Frontal CTX","Temporal CTX","Parietal CTX","Occipital CTX")

## Select only cortical expression
dat = dat[dat$Region %in% cortex, ]
summary(subset(dat,Unit=="Prenatal (Post-Conception Week)"))
dat = dat[dat$Age<45,]

p.brainExp = 
 ggplot(dat,aes(x=Unit, y=Expr, fill=Unit, alpha=Unit)) + 
  #ylab("Normalized expression") +  geom_boxplot(outlier.size = NA)  +
  ylab("Normalized expression") +  geom_violin() + geom_jitter(height = 0, width = 0.1) +
  ggtitle("Brain Expression") + xlab("") +
  scale_alpha_manual(values=c(0.2, 1)) + scale_fill_manual(values=c("yellowgreen", "springgreen3")) +theme_classic()+theme(legend.position="na")
pdf(file="60HMAGMA/developmentalexpression.pdf")
p.brainExp
dev.off()

p.brainspanTime = 
  ggplot(dat,aes(x=Age, y= Expr, fill=Unit, color=Unit)) + geom_jitter(alpha=.2,width=2) + ylab("Normalized expression") + 
  geom_smooth(span=1) + 
  scale_fill_manual(values=c("yellowgreen","springgreen3")) + scale_colour_manual(values=c("yellowgreen","springgreen3"))+ facet_grid(.~Unit, scales="free_x",space="free_x") + xlab("Prenatal Age (week)                                             Postnatal Age (year)") +theme_classic()+theme(legend.position="na")+
ggtitle("Brain Developmental Expression Trajectory")

pdf(file="60HMAGMA/developmentalexpressionTrajectory.pdf",width=8,height=7)
p.brainspanTime
dev.off()

res = t.test(dat[dat$Unit == "Prenatal (Post-Conception Week)","Expr"],dat[dat$Unit != "Prenatal (Post-Conception Week)","Expr"])
summary(res)
res$p.value
