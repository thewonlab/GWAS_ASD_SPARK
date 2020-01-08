library(ggplot2)
library(GGally)
library(viridis)
options(stringsAsFactors=F)

input <- commandArgs(trailingOnly=TRUE)[1]

mds_cluster <- read.table(input, header=T,sep="\t");
head(mds_cluster)

#5SD
EUR_C1<-c(mean(subset(mds_cluster,population=="CEU"|population=="TSI")$C1)-5*sd(subset(mds_cluster,population=="CEU"|population=="TSI")$C1),mean(subset(mds_cluster,population=="CEU"|population=="TSI")$C1)+5*sd(subset(mds_cluster,population=="CEU"|population=="TSI")$C1))
EUR_C2<-c(mean(subset(mds_cluster,population=="CEU"|population=="TSI")$C2)-5*sd(subset(mds_cluster,population=="CEU"|population=="TSI")$C2),mean(subset(mds_cluster,population=="CEU"|population=="TSI")$C2)+5*sd(subset(mds_cluster,population=="CEU"|population=="TSI")$C2))
EAS_C1<-c(mean(subset(mds_cluster,population=="CHB"|population=="CHD"|population=="JPT")$C1)-5*sd(subset(mds_cluster,population=="CHB"|population=="CHD"|population=="JPT")$C1),mean(subset(mds_cluster,population=="CHB"|population=="CHD"|population=="JPT")$C1)+5*sd(subset(mds_cluster,population=="CHB"|population=="CHD"|population=="JPT")$C1))
EAS_C2<-c(mean(subset(mds_cluster,population=="CHB"|population=="CHD"|population=="JPT")$C2)-5*sd(subset(mds_cluster,population=="CHB"|population=="CHD"|population=="JPT")$C2),mean(subset(mds_cluster,population=="CHB"|population=="CHD"|population=="JPT")$C2)+5*sd(subset(mds_cluster,population=="CHB"|population=="CHD"|population=="JPT")$C2))
AFR_C1<-c(mean(subset(mds_cluster,population=="YRI"|population=="LWK")$C1)-5*sd(subset(mds_cluster,population=="YRI"|population=="LWK")$C1),mean(subset(mds_cluster,population=="YRI"|population=="LWK")$C1)+5*sd(subset(mds_cluster,population=="YRI"|population=="LWK")$C1))
AFR_C2<-c(mean(subset(mds_cluster,population=="YRI"|population=="LWK")$C2)-5*sd(subset(mds_cluster,population=="YRI"|population=="LWK")$C2),mean(subset(mds_cluster,population=="YRI"|population=="LWK")$C2)+5*sd(subset(mds_cluster,population=="YRI"|population=="LWK")$C2))

# Get density of points in 2 dimensions.
# @param x A numeric vector.
# @param y A numeric vector.
# @param n Create a square n by n grid to compute density.
# @return The density within each square.
get_density <- function(x, y, ...) {
  dens <- MASS::kde2d(x, y, ...)
  ix <- findInterval(x, dens$x)
  iy <- findInterval(y, dens$y)
  ii <- cbind(ix, iy)
  return(dens$z[ii])
}


myColor <- rev(RColorBrewer::brewer.pal(11, "Spectral"))
myColor_scale_color <- scale_color_gradientn(colours = myColor)

mds_spark_trio<-subset(mds_cluster,population=="This study")
mds_spark_trio$density <- get_density(mds_spark_trio$C1, mds_spark_trio$C2, n = 100)

EUR_TRIO<-subset(mds_spark_trio,C1 >= EUR_C1[1] & C1 <= EUR_C1[2] & C2 >= EUR_C2[1] & C2 <= EUR_C2[2])
EAS_TRIO<-subset(mds_spark_trio,C1 >= EAS_C1[1] & C1 <= EAS_C1[2] & C2 >= EAS_C2[1] & C2 <= EAS_C2[2])
AFR_TRIO<-subset(mds_spark_trio,C1 >= AFR_C1[1] & C1 <= AFR_C1[2] & C2 >= AFR_C2[1] & C2 <= AFR_C2[2])

write.table(file="01_Trios/20190503v1/population/EUR_QC4_5SD",EUR_TRIO[c("FID","IID")],row.names=F,quote=F,sep="\t")
write.table(file="01_Trios/20190503v1/population/EAS_QC4_5SD",EAS_TRIO[c("FID","IID")],row.names=F,quote=F,sep="\t")
write.table(file="01_Trios/20190503v1/population/AFR_QC4_5SD",AFR_TRIO[c("FID","IID")],row.names=F,quote=F,sep="\t")

pdf(file="98Plots/mdsplot_spark_trio_cases_density.pdf",useDingbats=FALSE)
theme_set(theme_bw(base_size = 16))
ggplot(mds_spark_trio) + geom_point(aes(C1, C2, color = density),size=0.7) + myColor_scale_color + annotate("rect",xmin=EUR_C1[1],xmax=EUR_C1[2],ymin=EUR_C2[1],ymax=EUR_C2[2],alpha = .2) + annotate("rect",xmin=EAS_C1[1],xmax=EAS_C1[2],ymin=EAS_C2[1],ymax=EAS_C2[2],alpha = .2)+annotate("rect",xmin=AFR_C1[1],xmax=AFR_C1[2],ymin=AFR_C2[1],ymax=AFR_C2[2],alpha = .2) +xlim(-0.18,0.05)+ylim(-0.18,0.10)+coord_equal()
ggplot(mds_spark_trio) + geom_point(aes(C1, C2, color = density),size=0.7) + myColor_scale_color + annotate("rect",xmin=EUR_C1[1],xmax=EUR_C1[2],ymin=EUR_C2[1],ymax=EUR_C2[2],alpha = .2) + annotate("rect",xmin=EAS_C1[1],xmax=EAS_C1[2],ymin=EAS_C2[1],ymax=EAS_C2[2],alpha = .2)+annotate("rect",xmin=AFR_C1[1],xmax=AFR_C1[2],ymin=AFR_C2[1],ymax=AFR_C2[2],alpha = .2) +xlim(-0.18,0.1)+ylim(-0.18,0.10)+coord_equal()+theme(legend.pos="na")
dev.off()

pdf(file="98Plots/mdsplot_HapMap_calc_by_w_trio_cases.pdf",useDingbats=FALSE)
hapmap<-subset(mds_cluster,population!="This study")
theme_set(theme_bw(base_size = 16))
ggplot(hapmap) + geom_point(aes(C1, C2, color = population),size=0.7) +scale_colour_manual(labels=c("ASW","CEU","CHB","CHD","GIH","JPT","LWK","MEX","MKK","TSI","YRI"),values=c("darkolivegreen","lightblue","brown","orange","black","purple","magenta","grey50","darkblue","#88eca7","yellow"))+ scale_fill_manual(labels=c("ASW","CEU","CHB","CHD","GIH","JPT","LWK","MEX","MKK","TSI","YRI"),values=c("darkolivegreen","lightblue","brown","orange","black","purple","magenta","grey50","darkblue","#88eca7","yellow"))+ annotate("rect",xmin=EUR_C1[1],xmax=EUR_C1[2],ymin=EUR_C2[1],ymax=EUR_C2[2],alpha = .2) + annotate("rect",xmin=EAS_C1[1],xmax=EAS_C1[2],ymin=EAS_C2[1],ymax=EAS_C2[2],alpha = .2)+annotate("rect",xmin=AFR_C1[1],xmax=AFR_C1[2],ymin=AFR_C2[1],ymax=AFR_C2[2],alpha = .2) +xlim(-0.18,0.1)+ylim(-0.18,0.10)+ coord_equal()+theme(legend.pos="na")
dev.off()
