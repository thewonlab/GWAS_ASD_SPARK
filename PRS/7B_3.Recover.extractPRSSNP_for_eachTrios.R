options(stringsAsFactors=F)

chr = Sys.getenv('SLURM_ARRAY_TASK_ID')

for(fam in 1:4097){
 dir=paste0("70PRS/10POOPRS/Target/Fam/",fam,"/")
 file=paste0(dir,"chr",chr,".haps")
 sfile=paste0(dir,"chr",chr,".sample")
 keep=paste0("70PRS/10POOPRS/Target/Fam/",fam,"/members.txt")
 if(file.size(file) == 0 |file.exists(sfile) == FALSE) {
  cmd = paste0('module load plink/2.00a-20190527 && ',
  ' plink2 -pfile 70PRS/10POOPRS/Target/',chr ,
  ' --export vcf vcf-dosage=HDS --keep ', keep,
  ' --geno 0 ',
  ' --out ',dir,'chr',chr,'_tmp')
  system(cmd)
  cmd = paste0('grep -v \'#\' ', dir,'chr',chr,'_tmp.vcf |grep \'/\' |cut -f3 > ',dir,'chr',chr,'_removeSNPs.txt')
  system(cmd)
  cmd = paste0('module load plink/2.00a-20190527 && ',
  ' plink2 -pfile 70PRS/10POOPRS/Target/',chr ,
  ' --keep ', keep, 
  ' --exclude ', dir, 'chr',chr,'_removeSNPs.txt ',
  ' --export haps ref-first',
  ' --geno 0 --out ',dir,'chr',chr)
  system(cmd)
 }
}
