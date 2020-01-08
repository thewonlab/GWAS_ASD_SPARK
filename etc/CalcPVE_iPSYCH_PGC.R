library(lubridate)
# Prevalence
K = 0.012

load("25GWASData/ASD_BenNeale/iPSYCHPGC_lifover_to_HG38.rdata")

calc_C<- function(K,P){
  K  # Prevalence in the population
  P  # Proportion of cases in the sample
  t=qnorm(K,lower.tail=F)
  z=dnorm(t)
  c=(K * (1-K))^2 / (z^2 * P * (1-P))
  return(c)
}

snplist=c("rs910805","rs10099100","rs71190156")

for(i in snplist){
 dt = iPSYCHPGC_df38_final[iPSYCHPGC_df38_final$SNP==i,]
 print(head(dt))
 
 beta = log(dt$OR)
 beta2 = (beta)^2
 Nca = dt$Nca
 Nco = dt$Nco
 SE = dt$SE
 FRQ_A = (Nca*dt$FRQ_A_18381 + Nco*dt$FRQ_U_27969)/(Nca+Nco)
 if(FRQ_A > 0.5){
  MAF = 1 - FRQ_A
 } else {
  MAF = FRQ_A
 }
 if(!exists("H2_obs")){
  H2_obs = (2*beta2*MAF*(1 - MAF))/(2*beta2*MAF*(1 - MAF) + ((SE)^2)*2*(Nca+Nco)*MAF*(1 - MAF))
 }else{
  H2_obs_tmp = (2*beta2*MAF*(1 - MAF))/(2*beta2*MAF*(1 - MAF) + ((SE)^2)*2*(Nca+Nco)*MAF*(1 - MAF))
  H2_obs = H2_obs + H2_obs_tmp
  rm(H2_obs_tmp)
 }
 print(H2_obs)
}

P = Nca/(Nca + Nco)
cat(paste0(as.character(Sys.time()),"\n"),file="97Results/PVE_iPSYCH_PGC.txt",append=TRUE)
cat(paste0("K (Prevalence in the population): ", K,"\n"),file="97Results/PVE_iPSYCH_PGC.txt",append=TRUE)
cat(paste0("P (Proportion of cases in sample): ",P,"\n"),file="97Results/PVE_iPSYCH_PGC.txt",append=TRUE)
cat("SNPs used in this calculation:\n",file="97Results/PVE_iPSYCH_PGC.txt",append=TRUE)
cat(snplist,file="97Results/PVE_iPSYCH_PGC.txt",append=TRUE)
cat("\n\n",file="97Results/PVE_iPSYCH_PGC.txt",append=TRUE)

cat(paste0("H2_obs(%): ", H2_obs*100,"\n"),file="97Results/PVE_iPSYCH_PGC.txt",append=TRUE)
#Convert H2(observed scale) to H2(Liability scale)
H2_l = H2_obs*calc_C(K,P)
cat(paste0("H2_l(%): ", H2_l*100,"\n"),file="97Results/PVE_iPSYCH_PGC.txt",append=TRUE)

