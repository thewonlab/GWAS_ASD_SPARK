### 4_evaluatePRS.R

rm(list=ls())
library(pROC)
library(fmsb)
library(ggpubr)
options(stringsAsFactors = FALSE)

setwd("70PRS/04PRS_WKDIR/prsice/")
load("3_meta_finalPRS.QC.RData")

name="ASD"

pdf(file="plots/ASD_SPARK_prsice-prs-final_all_together_20190930.QC.pdf",useDingbats=F)

tst=data.frame(ASD=dx,PRS=asd_prs_All$T5)
colnames(tst)[2] = "PRS"
tst$ASD = ifelse(tst$ASD=="1","Case","Control")

p = ggviolin(tst, x = "ASD", y = "PRS", color = "ASD", palette = "jco", add = "boxplot",alpha=0.5) 
p = p+ stat_compare_means(aes(label = paste0("p=",round(..p..,21))), 
                        label.x = 1.5, label.y = 0.0021,paired=TRUE)
p

str(tst)
p = ggdensity(tst, x = "PRS", rug= TRUE, color = "ASD", fill = "ASD",
   palette = c("#00AFBB", "#E7B800"))
p

p1 = ggviolin(tst, x = "ASD", y = "PRS", color = "ASD", palette = "jco", add = "boxplot",alpha=0.5,rotate=T) 
p1= p1+ stat_compare_means(aes(label = paste0("p=",round(..p..,21))), 
                        label.x = 1.5, label.y = 0.0019,paired=TRUE)
ggarrange(p, p1, heights = c(2, 0.7),
          ncol = 1, nrow = 2, align = "v")

###comparison across Family type
meta_wFinfo = data.frame(meta)
meta_wFinfo_case = meta_wFinfo[c(TRUE,FALSE),]

tst2=data.frame(FamilyType=meta_wFinfo_case$FamilyType,PRS=asd_prs_CaseOnlyPCSEX$T5)
colnames(tst2)[2] = "PRS"

my_comparisons <- list( c("1", "4"), c("2", "4"),c("3","4") )
ggviolin(tst2, x = "FamilyType", y = "PRS",
          color = "FamilyType", palette = "jco",add="boxplot",alpha=0.5)+ 
  stat_compare_means(comparisons = my_comparisons)+ # Add pairwise comparisons p-value
  stat_compare_means(label.y = 0.0031)     # Add global p-value

#SEX (case-pseudo)

comb=data.frame(cbind(meta,asd_prs_All$T5))
colnames(comb)[15]="PRS"
comb_female=comb[comb$Sex==1,]
comb_male=comb[comb$Sex==0,]
comb_female[,"ASD"] <- c("1","0")
comb_male[,"ASD"] <- c("1","0")
#
p = ggboxplot(comb_female, x = "ASD", y = "PRS", color = "ASD", palette = "jco", add = "jitter",alpha=0.5)
p = p+ stat_compare_means(aes(label = paste0("p=",round(..p..,21))),
                        label.x = 1.5, label.y = 0.0021,paired=TRUE)
p
p = ggboxplot(comb_male, x = "ASD", y = "PRS", color = "ASD", palette = "jco", add = "jitter",alpha=0.5)
p = p+ stat_compare_means(aes(label = paste0("p=",round(..p..,21))),
                        label.x = 1.5, label.y = 0.0021,paired=TRUE)
p

comb_mod=rbind(comb_female,comb_male)
comb_mod$Sex=ifelse(comb_mod$Sex==0,"Male","Female")
comb_mod$ASD=ifelse(comb_mod$ASD==0,"Control","Case")
meanv=c(mean(subset(comb_male,ASD==0,)$PRS),mean(subset(comb_female,ASD==1,)$PRS))
length(meanv)

p =  ggplot(comb_mod)+geom_histogram(aes(x=PRS,color=paste(ASD,Sex,"_")),fill="white",alpha=0.5, position="identity")+facet_grid(Sex~ASD,scales = "free_y")+theme_classic()+theme(legend.pos="na")
p

#sex across families
tst3=data.frame(Sex=meta_wFinfo_case$Sex,PRS=asd_prs_CaseOnlyPC$T5)
colnames(tst3)[2]="PRS"

tst3$Sex = ifelse(tst3$Sex=="1","Female","Male")
p = ggviolin(tst3, x = "Sex", y = "PRS", color = "Sex", palette = "jco", add = "boxplot",alpha=0.5) 
p = p+ stat_compare_means(aes(label = paste0("p=",round(..p..,21))),
                        label.x = 1.5, label.y = 0.0021,paired=F)
p

dev.off()
