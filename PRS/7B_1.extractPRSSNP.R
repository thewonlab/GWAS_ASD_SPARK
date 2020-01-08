options(stringsAsFactors=F)

prs_snps = read.table("70PRS/04PRS_WKDIR/prsice/rawPRS_CC_QC/ASD_SPARK_EUR_SPARK.snp",header=T)

keep="70PRS/10POOPRS/Target/AllSample.txt" # list of 12,291 individuals from 4,097 trios (fid, iid, without header)

for(chr in 1:22){
 snp = prs_snps[prs_snps$CHR==chr,"SNP"]
 write.table(snp,paste0("70PRS/10POOPRS/Base/chr",chr,".txt"),quote=F,row.names=F,col.names=F)

 rsidfile=paste0("02IMPUTATION/imputed/20190423/20190530/trios/chr",chr,".pos.id.tsv")
 cmd = paste0('sbatch -o 70PRS/10POOPRS/Target/chr',chr,'.slurm.log',
 ' --wrap=\"module load plink/2.00a-20190527 && ',
 ' plink2 -pgen 02IMPUTATION/imputed/20190423/20190624/plink/chr',chr,'_HDS.pgen',
 ' --psam 20GWAS/201905/trio_4/plink/20190423_20190624.psam',
 ' --pvar 02IMPUTATION/imputed/20190423/20190624/plink/chr',chr,'_HDS.pvar',
 ' --extract 70PRS/10POOPRS/Base/chr',chr,'.txt',
 ' --keep ' ,keep, 
 ' --minimac3-r2-filter 0.5 --maf 0.05 minor ',
 ' --update-sex 40POO/20190730/model1_ParentsSexInfo.txt',
 ' --update-name ', rsidfile, ' 6 1',
 ' --ref-allele ', rsidfile, ' 4 6',
 ' --make-pgen ',
 ' --out 70PRS/10POOPRS/Target/',chr,'\"')
 system(cmd)
}

