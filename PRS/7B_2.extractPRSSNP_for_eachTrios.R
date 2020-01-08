options(stringsAsFactors=F)

slurm_arrayid = Sys.getenv('SLURM_ARRAY_TASK_ID')

keep = paste0("70PRS/10POOPRS/Target/Fam/",slurm_arrayid,"/members.txt")

for(chr in 1:22){
 cmd = paste0('module load plink/2.00a-20190527 && ',
 ' plink2 -pfile 70PRS/10POOPRS/Target/',chr ,
 ' --keep ' ,keep, 
 ' --export haps ref-first',
 ' --geno 0 --out 70PRS/10POOPRS/Target/Fam/',slurm_arrayid,'/chr',chr)
 system(cmd)
}

