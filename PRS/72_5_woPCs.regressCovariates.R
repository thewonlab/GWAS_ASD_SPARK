### 2_regressCovariates.R

### this code was adapted from jillhaney21@g.ucla.edu
### script to regress out covariates other than disease condition (ie. sex, ancestry, etc.) from PRS's

rm(list=ls())
options(stringsAsFactors = FALSE)

setwd("70PRS/04PRS_WKDIR/prsice/")
load("1_meta_nonreg_data.QC.RData")

### Regress out 10 PCs, and sex from PRS (for case only comparison)
meta_PC_case = data.matrix(meta[c(TRUE,FALSE),-c(1:4)])
meta_PC_sex_case = data.matrix(meta[c(TRUE,FALSE),-c(1,3,4)])

asd_prs_ctrl = asd_prs[c(FALSE,TRUE),]
asd_prs_case = asd_prs[c(TRUE,FALSE),]
asd_prs_case_adjPC = asd_prs_case
asd_prs_case_adjPC_sex = asd_prs_case
 
for(i in c(2:11)){
 tmp=summary(lm(asd_prs_case[,i]~+meta_PC_case))
 asd_prs_case_adjPC[,i]=asd_prs_case[,i]-tmp$coefficients[2,1]*meta_PC_case[,1]-tmp$coefficients[3,1]*meta_PC_case[,2] -tmp$coefficients[4,1]*meta_PC_case[,3] -tmp$coefficients[5,1]*meta_PC_case[,4] -tmp$coefficients[6,1]*meta_PC_case[,5] -tmp$coefficients[7,1]*meta_PC_case[,6] -tmp$coefficients[8,1]*meta_PC_case[,7] -tmp$coefficients[9,1]*meta_PC_case[,8] -tmp$coefficients[10,1]*meta_PC_case[,9] -tmp$coefficients[11,1]*meta_PC_case[,10] 

 tmp=summary(lm(asd_prs_case[,i]~+meta_PC_sex_case))
 asd_prs_case_adjPC_sex[,i]=asd_prs_case[,i]-tmp$coefficients[2,1]*meta_PC_sex_case[,1]-tmp$coefficients[3,1]*meta_PC_sex_case[,2] -tmp$coefficients[4,1]*meta_PC_sex_case[,3] -tmp$coefficients[5,1]*meta_PC_sex_case[,4] -tmp$coefficients[6,1]*meta_PC_sex_case[,5] -tmp$coefficients[7,1]*meta_PC_sex_case[,6] -tmp$coefficients[8,1]*meta_PC_sex_case[,7] -tmp$coefficients[9,1]*meta_PC_sex_case[,8] -tmp$coefficients[10,1]*meta_PC_sex_case[,9]-tmp$coefficients[11,1]*meta_PC_sex_case[,10] -tmp$coefficients[12,1]*meta_PC_sex_case[,11]
}

save(dx,meta,asd_prs,asd_prs_ctrl,asd_prs_case,asd_prs_case_adjPC,asd_prs_case_adjPC_sex,file="2_meta_nonreg_data.QC.RData")

