library(GenomicRanges)
library(gProfileR)
library(ggplot2)
library(forcats)
options(stringsAsFactors=F)
load("/proj/hyejunglab/chr/geneAnno_allgenes.rda")
setdir="60HMAGMA/GO/"
inputdir="60HMAGMA/"
backgroundset = unique(geneAnno1[geneAnno1$gene_biotype=="protein_coding", "ensembl_gene_id"])
celltypes = c("FB","AB")
MHCrange = GRanges(seqnames=6, IRanges(25000000,35000000))  

diseasename ="SPARK_EUR_Meta"

for(j in 1:length(celltypes)){
  goresult = vector(length=length(diseasename), mode="list")
  celltype = celltypes[j]
  for(i in 1:length(diseasename)) {
  diseasemat = read.table(paste0(inputdir,diseasename[i],"_MAGMA_",celltype,".genes.out"), header=T)
  diseasemat = diseasemat[diseasemat$GENE %in% backgroundset, ]
  diseaseranges = GRanges(seqnames=diseasemat$CHR, IRanges(diseasemat$START, diseasemat$STOP), ensg=diseasemat$GENE, P=diseasemat$P)
  olap = findOverlaps(diseaseranges, MHCrange)
  diseasemhc = diseaseranges[queryHits(olap)]
  mhcgene = diseasemhc$ensg
  diseasemat = diseasemat[!(diseasemat$GENE %in% mhcgene), ]
  
  backgroundensg = diseasemat$GENE
  queryensg = diseasemat[order(diseasemat$P),"GENE"]
 
  goresult[[i]] = gprofiler(queryensg, organism="hsapiens", ordered_query=T, significant=T, 
                            max_p_value=0.05, min_set_size=15, max_set_size=600,
                            min_isect_size=5, correction_method="fdr",
                            hier_filtering="strong", custom_bg=backgroundensg, include_graph=T, src_filter=c("GO:BP", "GO:MF"))
  ## Notice that hierarchical filering will remove redundant terms; if you don't want this, set hier_filtering="none"
  print(diseasename[i])
  print(head(goresult[i]$term.name))
  res<-data.frame(goresult[i])  
  write.table(res[c(1:12)],paste0(setdir,"GO_GSEA_protein-coding_genes_MHCextrm_strongfilter_", celltype, "_BP_MF.tsv"),quote=F,row.names=F,sep="\t")
}
  names(goresult) <- diseasename
  save(goresult, file=paste0(setdir,"GO_GSEA_protein-coding_genes_MHCextrm_strongfilter_", celltype, "_BP_MF.rda"))
}
