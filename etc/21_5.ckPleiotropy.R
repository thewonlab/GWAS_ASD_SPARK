options(stringsAsFactors=F)
gwas_full = read.delim("00conf/gwas_catalog_v1.0-associations_e96_r2019-10-14.tsv",header=T,quote = "")
gwas = gwas_full[c(2,5,7,8,9,10,12,13,21,22,28,31)]
gwas_study = gwas_full[c(2,5,7,8)]
gwas = gwas[gwas$CHR_ID!="",]
gwas = gwas[!grepl(";",gwas$SNPS),]
gwas = gwas[!grepl("x",gwas$SNPS),]
gwas$CHR_POS = as.numeric(gwas$CHR_POS)
gwas_sig = gwas[gwas$P.VALUE < 0.00000005,]
pos_chr = c(17,1,8,20,8)
pos_start = c(45000000,95600000,10219402,20752781,38193334)
pos_end = c(47000000,97000000,11219402,21752781,38692017)
ldfile_dir = c(1,1,1,1,2)
ldfile = c("chr17_45887763.ld","chr1_96104001.ld","chr8_10719265.ld","chr20_21252560.ld","chr8_38442106_EUR.ld")

for(i in 1:length(pos_chr)){
 print(paste0("chr",pos_chr))
 gwas_sig_coloc = gwas_sig[gwas_sig$CHR_ID == pos_chr[i] & gwas_sig$CHR_POS > pos_start[i] & gwas_sig$CHR_POS < pos_end[i],]
 if(ldfile_dir[i] == 1){
  ld = read.table(paste0("20GWAS/201905/trio_4/plink/ld/",ldfile[i]),header=T)
 }else{
  ld = read.table(paste0("21FUNCTION/02eQTL/ld/",ldfile[i]),header=T)
 }

 ld = ld[ld$R2 > 0.8,]
 gwas_sig_coloc = merge(gwas_sig_coloc, ld,by.x="SNPS",by.y="SNP_B")
 print(colnames(gwas_sig_coloc))
 write.table(gwas_sig_coloc[c(1,2,5,8:12,15,18)],file=paste0("21FUNCTION/05Pleiotropy/",i,"_gwas_cat_chr",pos_chr[i],".tsv"),quote=F,row.names=F,sep="\t")
