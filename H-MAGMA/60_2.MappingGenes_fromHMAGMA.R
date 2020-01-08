options(stringsAsFactors=F)
celltype=c("FB","AB")
fdr=0.1
for(i in 1:length(celltype)){
 print(celltype[i])
 res<-read.table(paste0("60HMAGMA/SPARK_EUR_Meta_MAGMA_",celltype[i],".genes.out"),header=T)
 res$FDR<-p.adjust(res$P,"BH")
 load("/proj/hyejunglab/chr/geneAnno_allgenes.rda")
 ProteinCoding<-subset(geneAnno1,gene_biotype=="protein_coding")
 merge_all = merge(res,geneAnno1,by.x="GENE",by.y="ensembl_gene_id")
 print(nrow(merge_all))
 merge_protein = merge_all[merge_all$gene_biotype=="protein_coding",]
 print(nrow(merge_protein))
 sig_all<-merge_all[merge_all$FDR <  fdr,]
 sig_protein<-merge_protein[merge_protein$FDR < fdr,]
 print(nrow(sig_protein))
 write.table(sig_protein[c("GENE","hgnc_symbol")],paste0("60HMAGMA/FDR",fdr,"_",celltype[i],"_ProteinCodingGenesList"),row.names=F,quote=F,sep="\t")
 write.table(sig_protein[c(1,2,3,9,10,11)],file=paste0("60HMAGMA/FDR",fdr,"_",celltype[i],"_ProteinCodingGeneList_AllTable"),row.names=F,quote=F,sep="\t")
 write.table(sig_all[c("GENE","hgnc_symbol")],paste0("60HMAGMA/FDR",fdr,"_",celltype[i],"_GenesList"),row.names=F,quote=F,sep="\t")
 write.table(sig_all,paste0("60HMAGMA/FDR",fdr,"_",celltype[i],"_GenesList_AllTable"),row.names=F,quote=F,sep="\t")
}

ASD_SPARK_AB<-read.table(paste0("60HMAGMA/FDR0.1_AB_GenesList"),header=T, fill = TRUE)
ASD_SPARK_FB<-read.table(paste0("60HMAGMA/FDR0.1_FB_GenesList"),header=T, fill = TRUE)
ASD_SPARK_AB_FB<-rbind(ASD_SPARK_AB,ASD_SPARK_FB)
ASD_SPARK_AB_FB_unique<-unique(ASD_SPARK_AB_FB)
save(ASD_SPARK_AB_FB_unique,file="60HMAGMA/FDR0.1_AB_FB_GenesList.rda")
