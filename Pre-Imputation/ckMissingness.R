library(ggplot2)

rootname <- commandArgs(trailingOnly=TRUE)[1]
output_type <- commandArgs(trailingOnly=TRUE)[2]
output <- commandArgs(trailingOnly=TRUE)[3]
print(output)

indmiss<-read.table(file=paste(rootname,"imiss",sep="."), header=TRUE)
snpmiss<-read.table(file=paste(rootname,"lmiss",sep="."), header=TRUE)

head(indmiss)
head(snpmiss)

if(output_type == "pdf") {
 pdf(paste(output,"indivmiss.pdf",sep=".")) 
 ggplot(indmiss)+geom_histogram(aes(x=F_MISS),bins=100)+theme_classic()+labs(title = "Histogram of missingness", subtitle = "Individuals")
 dev.off()
 pdf(paste(output,"snpmiss.pdf",sep="."))
 ggplot(snpmiss)+geom_histogram(aes(x=F_MISS),bins=100)+theme_classic()+labs(title = "Histogram of missingness", subtitle = "SNPs")
 dev.off()
}
if(output_type == "png") {
 print("OK")
 print(paste(output,"indivmiss.png",sep="."))
 png(paste(output,"indivmiss.png",sep=".")) 
 p<-ggplot(indmiss)+geom_histogram(aes(x=F_MISS),bins=100)+theme_classic()+labs(title = "Histogram of missingness", subtitle = "Individuals")
 print(p)
 dev.off()
 ggplot(indmiss)+geom_histogram(aes(x=F_MISS),bins=100)+theme_classic()+labs(title = "Histogram of missingness", subtitle = "Individuals")
 png(paste(output,"snpmiss.png",sep=".")) 
 p<-ggplot(snpmiss)+geom_histogram(aes(x=F_MISS),bins=100)+theme_classic()+labs(title = "Histogram of missingness", subtitle = "SNPs")
 print(p)
 dev.off()
}

