options(stringsAsFactors=F)
celltype="FB"
bg_HMAGMA = 18757
# FDR 0.1
sig_HMAGMA = 263

load("/proj/hyejunglab/chr/geneAnno_allgenes.rda")
ProteinCoding<-subset(geneAnno1,gene_biotype=="protein_coding")

asdgenes = read.delim("50LDSC/dataset/ASD102Genes/genelist.tsv")
asdgenes = asdgenes$ensembl_gene_id

deg = read.csv("/proj/hyejunglab/expression/ASD_RNAseq/ASD_cortical_module.csv")
deg = deg[deg$ENSEMBL.ID%in%geneAnno1$ensembl_gene_id,]
deggenes = deg$ENSEMBL.ID
#deggenes
asddowngenes = deg[deg$log2.FC..ASD.vs.CTL<0 & deg$FDR.adjusted.P.value..ASD.vs.CTL<0.05,"ENSEMBL.ID"]
asdupgenes = deg[deg$log2.FC..ASD.vs.CTL>0 & deg$FDR.adjusted.P.value..ASD.vs.CTL<0.05,"ENSEMBL.ID"]
asddowngenes = unique(asddowngenes[!is.na(asddowngenes)])
asdupgenes = unique(asdupgenes[!is.na(asdupgenes)])

cat("Overlap with ASD 102Genes\n")
print(paste0(celltype,"_0.1"),quote=F,row.names=F)
res<-read.table(paste0("60HMAGMA/SPARK_EUR_Meta_MAGMA_",celltype,".genes.out"),header=T)
merge_protein = merge(res,ProteinCoding,by.x="GENE",by.y="ensembl_gene_id")
ln_asdgenes = length(intersect(asdgenes,merge_protein$GENE))
filename = paste0("60HMAGMA/FDR0.1_",celltype,"_ProteinCodingGenesList")
asd_HMAGMA = read.table(filename,sep="\t",header=T)
common = asd_HMAGMA[asd_HMAGMA$GENE %in% asdgenes,"hgnc_symbol"]
print(paste(length(common), ln_asdgenes, bg_HMAGMA[i]-ln_asdgenes,sig_HMAGMA[i],sep=" "))
sig_p = phyper(length(common)-1, ln_asdgenes, bg_HMAGMA[i]-ln_asdgenes,sig_HMAGMA[i], lower.tail = FALSE)
print(paste0("significance for overlaps ", round(sig_p,5)), quote=F,row.names=F)
print(common,quote=F,row.names=F)

cat("\n")
cat("Overlap with ASD DEG Genes\n")

celltype="FB"

res<-read.table(paste0("60HMAGMA/SPARK_EUR_Meta_MAGMA_",celltype,".genes.out"),header=T)
res=res[res$GENE%in%geneAnno1$ensembl_gene_id,]
merge_background = res[res$GENE%in%deggenes,]
filename = paste0("60HMAGMA/FDR0.1_",celltype,"_ProteinCodingGenesList")
asd_HMAGMA = read.table(filename,sep="\t",header=T)

print("Down regulated genes",row.names=F,quote=F)
down_gene=asd_HMAGMA[asd_HMAGMA$GENE %in% asddowngenes,]
print(nrow(down_gene))
print(down_gene,quote=F,row.names=F)

print("Up regulated genes",row.names=F,quote=F)
up_gene=asd_HMAGMA[asd_HMAGMA$GENE %in% asdupgenes,]
print(nrow(up_gene))
print(up_gene,quote=F,row.names=F)

