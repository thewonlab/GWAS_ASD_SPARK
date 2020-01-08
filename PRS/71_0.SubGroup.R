options(stringsAsFactors=F)

cmd = "cut -f1,20 ../spark-work/SPARK_Freeze_Three_update_20190423/included/SPARK.27K.mastertable.20190501.txt|sort|uniq |grep -v sfid> 70PRS/00conf/FamilyStructure.txt"
system(cmd)

family = read.table("70PRS/00conf/FamilyStructure.txt",sep="\t")
colnames(family) = c("sfid","familytype1")
head(family)

# 0    : Simplex, only one child is affected
# 1    : one child and father are affected
# 2    : one child and mother are affected
# 3    : one child and both parents are affected
# 4    : multiple children and father are affected
# 5    : multiple children and mother are affected
# 6    : multiple children and both parents are affected
# 7    : multiple children are affected
# 8    : only one child affected, single mother
# 9    : only one child affected, single father
# 10   : only one child affected, no parent
# 11   : multiple child affected, single mother
# 12   : multiple child affected, single father
# 13   : multiple child affected, no parent

model1qc = read.table("20GWAS/201905/trio_4/plink/20190423_20190503v1_model1.final.indiv")
colnames(model1qc) = c("sfid","spid")
model1qc_case = model1qc[grep("-T",model1qc$spid),]
model1qc_case = merge(model1qc_case,family)

model1qc_case$type = ifelse(model1qc_case$familytype1==7,1,ifelse(model1qc_case$familytype1 > 3 , 2 , ifelse(model1qc_case$familytype1 > 0 , 3, 4))) 

eur=read.table("41EMIM/dataset/model1_eur_cases.parent")
colnames(eur)[c(1,2)] = c("sfid","spid")
model1qc_case_eur = merge(model1qc_case[c(1,2,4)],eur[c(1,2)])

model1qc_ctrl_eur = model1qc_case_eur
model1qc_ctrl_eur$spid = gsub("-T","-U",model1qc_ctrl_eur$spid)

model1qc_case_ctrl_eur = rbind(model1qc_case_eur,model1qc_ctrl_eur)

write.table(model1qc_case_ctrl_eur[c("sfid","spid","type")],file="70PRS/00conf/Fams_CC.txt",quote=F,row.names=F,col.names=F)
