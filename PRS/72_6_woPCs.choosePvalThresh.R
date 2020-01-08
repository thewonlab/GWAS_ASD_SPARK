### 3_choosePvalThresh.R
### this code was adapted from jillhaney21@g.ucla.edu

setwd("70PRS/04PRS_WKDIR/prsice/")
rm(list=ls())
options(stringsAsFactors = FALSE)

load("2_meta_nonreg_data.QC.RData")

library(ggplot2)
library(grDevices)

library(fmsb)
library(pROC)

pdf("plots/FamilyType_prsice-prs_Case-Pseudo.QC.pdf")
par(mar=c(6,6,3,6),xpd=TRUE,oma=c(0,0,0,0),mgp=c(4,1,0))

name = "ASD"
r_all=list()
coef_all=list()
pval_all=list()
  r=rep(NA,10)
  coef = rep(NA,10)
  pval = rep(NA,10)
  idx=c(2:11)
  
  for(i in c(1:10)){
    j=idx[i]
    y=unlist(asd_prs[j])
    boxplot(y~dx,main=paste(name,names(asd_prs)[j],sep=" "))
    prs_mod=glm(dx~y,family=binomial)
    r[i]=NagelkerkeR2(prs_mod)$R2
    tmp2=lm(y~dx)
    coef[i] = summary(tmp2)$coefficients[2]
    pval[i] = summary(tmp2)$coefficients[8]
  }  
  
  r_all[[name]]=r
  coef_all[[name]]=coef
  pval_all[[name]]=pval
  
  idx_pos = which(coef_all[[name]] >= 0)
  idx_neg = which(coef_all[[name]] < 0)
  
  if(length(idx_pos) > 0){  
    cols_plot = colorRampPalette(c("lightpink","red4"))
    order_coef=order(coef_all[[name]][idx_pos])
    order_coef2=cbind(c(1:length(idx_pos)),order_coef)
    order_coef3=order_coef2[order(order_coef2[,2]),1]
    coefcol_plot_pos=cols_plot(length(idx_pos))[order_coef3]
  }else{
    idx_pos=0
  }
  
  if(length(idx_neg) > 0){
    cols_plot = colorRampPalette(c("darkblue","lightblue"))
    order_coef=order(coef_all[[name]][idx_neg])
    order_coef2=cbind(c(1:length(idx_neg)),order_coef)
    order_coef3=order_coef2[order(order_coef2[,2]),1]
    coefcol_plot_neg=cols_plot(length(idx_neg))[order_coef3]
  }else{
    idx_neg=0
  }
  
  coefcol_plot = rep(NA,10)
  coefcol_plot[idx_pos]=coefcol_plot_pos
 # coefcol_plot[idx_neg]=coefcol_plot_neg
  
  bar_names=c("5e-08","1e-06","0.0001","0.001","0.01","0.05","0.1","0.2","0.5","1")
  
  bp=barplot(r_all[[name]],names.arg = bar_names,col = coefcol_plot,
          ylab="Nagelkerke R^2",cex.names = 0.9, xlab = "P Value Thresholds",main=name)
  text(bp, r_all[[name]]+0.0001,signif(pval_all[[name]],2) ,cex=0.5,sqrt = 30)
  legend("topright",inset=c(-0.25,0),paste("logFC=",signif(coef_all[[name]],3),sep=""),fill=coefcol_plot,cex = 0.7)
  print(pval_all[[name]])

dev.off()

asd_prs_All=asd_prs[names(asd_prs)=="T5"]
asd_prs_CaseOnlyPC=asd_prs_case_adjPC[names(asd_prs_case_adjPC)=="T5"]
asd_prs_CaseOnlyPCSEX=asd_prs_case_adjPC_sex[names(asd_prs_case_adjPC_sex)=="T5"]

save(dx,meta,asd_prs_All,asd_prs_CaseOnlyPC,asd_prs_CaseOnlyPCSEX,file="3_meta_finalPRS.QC.RData")
