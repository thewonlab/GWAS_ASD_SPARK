### Load necessary packages
options(stringsAsFactors = F)
library(dplyr)
library(reshape2)
library(ggplot2)
library(stringr)

##load .rda files of scz data (batch3) and loci info; object has batchvar;
load("/proj/hyejunglab/MPRA/RNAseq/variant1/HEK/batch3/fastq/batch3_RNAseq_sum_counts.rda")
locus=read.table("/proj/hyejunglab/disorder/ASD/ASD_SPARK/spark/SNPsofInterests/mpra_all_chr8_38M.tsv", header=T)

## find varid for the 98 variants
varnam = locus[,1]

## change list into data frame
var1 = batchvar[batchvar$SNP %in% varnam,]
varalt = as.data.frame(var1[seq(1,110,2),])
varref = as.data.frame(var1[seq(2,110,2),])

## load histogram data
bcstat = read.table("/proj/hyejunglab/MPRA/bcmapping/Batch3.sczvar/Batch3.400x/barcode_statistics.txt", header=T)
varstat = read.table("/proj/hyejunglab/MPRA/bcmapping/Batch3.sczvar/Batch3.400x/variant_statistics.txt", header=T, sep="\t")
varstat$rsid = sapply(strsplit(varstat[,2],"_"), function(x) x[2])
varstat = varstat[varstat$rsid %in% varnam,]
bcdat = data.frame(bcstat$num_reads_most_common)
vardat = data.frame(varstat$num_barcodes_unique)

## call histogram
pdf(paste0("VAR_histogram.pdf"), height=5, width=5)
b = ggplot(varstat, aes(x=num_barcodes_unique)) +
        geom_histogram(binwidth=20, fill="white", col="black") +
        xlim(c(-20,650)) + ylim(c(0,20)) +
        xlab("# of barcordes per variant") + ylab("Frequency") +
        ggtitle("Variant Frequency") + 
        theme_bw()
b + annotate("text", x=60, y=15, label=paste0("barcode coverage\nmin=",min(vardat), "\nmax=",max(vardat),"\nmean=", format(mean(signif(vardat,2)[,1]))),3)
dev.off()

## correlation data
#combine
vardata = sapply(strsplit(varalt[,1],"_"), function(x) x[2])
vardata = as.data.frame(vardata)
colnames(vardata) = "variant"
vardata$rna.s1 = varalt$rna.s1 + varref$rna.s1
vardata$rna.s2 = varalt$rna.s2 + varref$rna.s2
vardata$rna.s3 = varalt$rna.s3 + varref$rna.s3
vardata$rna.s4 = varalt$rna.s4 + varref$rna.s4
vardata$rna.s5 = varalt$rna.s5 + varref$rna.s5
vardata$rna.s6 = varalt$rna.s6 + varref$rna.s6
vardata$dna.s = varalt$dna.s + varref$dna.s
#percent
vardata$rs1ratio = log(vardata$rna.s1/vardata$dna.s)
vardata$rs2ratio = log(vardata$rna.s2/vardata$dna.s)
vardata$rs3ratio = log(vardata$rna.s3/vardata$dna.s)
vardata$rs4ratio = log(vardata$rna.s4/vardata$dna.s)
vardata$rs5ratio = log(vardata$rna.s5/vardata$dna.s)
vardata$rs6ratio = log(vardata$rna.s6/vardata$dna.s)

## call correlation pdf
pdf("rep_RNA_DNA_corr.pdf", height=5, width=5, useDingbats=FALSE)
genelm <- lm(vardata$rs1ratio~vardata$rs2ratio, na.action=na.exclude)
R <- format(sqrt(summary(genelm)$adj.r.squared),digits=2)
P <- format(summary(genelm)$coefficients[2,4],digits=2)
M <- format(summary(genelm)$coefficients[2,1],digits=2)
a = ggplot(vardata, aes(x=rs1ratio,y=rs2ratio)) +
        geom_point() + xlim(c(-1.75,0.75)) + ylim(c(-1.75,0.75)) +
        xlab("replicate 1") + ylab("replicate 2") +
        geom_smooth(method="lm", se=FALSE) +
        ggtitle("Replicate 1 vs. Replicate 2") +
        theme_bw()
a + annotate("text", x=-1, y=0.5, label=paste0("R=",R," p=",P," slope=",M))
genelm <- lm(vardata$rs1ratio~vardata$rs3ratio, na.action=na.exclude)
R <- format(sqrt(summary(genelm)$adj.r.squared),digits=2)
P <- format(summary(genelm)$coefficients[2,4],digits=2)
M <- format(summary(genelm)$coefficients[2,1],digits=2)
a = ggplot(vardata, aes(x=rs1ratio,y=rs3ratio)) +
        geom_point() + xlim(c(-1.75,0.75)) + ylim(c(-1.75,0.75)) +
        xlab("replicate 1") + ylab("replicate 3") +
        geom_smooth(method="lm", se=FALSE) +
        ggtitle("Replicate 1 vs. Replicate 3") +
        theme_bw()
a + annotate("text", x=-1, y=0, label=paste0("R=",R," p=",P," slope=",M))
genelm <- lm(vardata$rs2ratio~vardata$rs3ratio, na.action=na.exclude)
R <- format(sqrt(summary(genelm)$adj.r.squared),digits=2)
P <- format(summary(genelm)$coefficients[2,4],digits=2)
M <- format(summary(genelm)$coefficients[2,1],digits=2)
a = ggplot(vardata, aes(x=rs2ratio,y=rs3ratio)) +
        geom_point() + xlim(c(-1.75,0.75)) + ylim(c(-1.75,0.75)) +
        xlab("replicate 2") + ylab("replicate 3") +
        geom_smooth(method="lm", se=FALSE) +
        ggtitle("Replicate 2 vs. Replicate 3") +
        theme_bw()
a + annotate("text", x=-1, y=0, label=paste0("R=",R," p=",P," slope=",M))
dev.off()

## process logFC/p-value data
locus$ref = toupper(locus$ref)
locus$alt = toupper(locus$alt)
locus$logFC.cor = ifelse(locus$ref==locus$Protective, locus$logFC, -locus$logFC)# corrected logFC (based on risk vs. protective)
locus$neglog10P = -log10(locus$adj.P.Val)
locus$variant_type = "other variants"
locus$variant_type[abs(locus$logFC.cor)>0.4 & locus$neglog10P>(-log10(0.01))] = "significant variants"
locus$variant_type[locus$SNP == "rs7001340"] = "top significant variant"

## call logFC/p-value pdf
pdf("logFC_adjustedP_locus_plot.pdf", height=5, width=7, useDingbats=FALSE)
a = ggplot(locus, aes(x=logFC.cor, y=neglog10P)) +
        xlab("logFC (Risk vs. Protective)") +
        ylab("-log10(FDR)") +
        ggtitle("MPRA plot for top variants") +
        geom_point(size = 2.5, aes(color = locus$variant_type, shape = locus$variant_type)) +
        geom_text(data=locus[locus$SNP == "rs7001340",], aes(x=logFC.cor*1.2, y=neglog10P, label="rs7001340")) +
        theme_bw() +
        scale_shape_manual(values=c(1,1,16)) +
        scale_color_manual(values=c("grey60","blue","blue"))
a +
        geom_vline(xintercept=log(1.5), linetype="dashed") +
        geom_vline(xintercept=-log(1.5), linetype="dashed") +
        geom_hline(yintercept=-log10(0.01), linetype="dashed")
dev.off()

## GC content
bcmap = read.table("/proj/hyejunglab/MPRA/bcmapping/Batch3.sczvar/Batch3.400x/variant_statistics.txt", header=T, sep="\t")

## select out variants of interest using $name column: it should have ref and alt
variant1 = locus[,1] # c("rs16887340","rs12681501","rs16887340","rs7001340")
bcmap$rsid = unlist(lapply(strsplit(bcmap$name, split="_"),'[[',2))
bcmap$refalt = unlist(lapply(strsplit(bcmap$name, split="_"),'[[',4))
bcvar.alt = bcmap[grep("alt", bcmap$refalt),]
bcvar.ref = bcmap[grep("ref", bcmap$refalt),]
bcvar.alt = bcvar.alt[match(variant1, bcvar.alt$rsid),]
bcvar.ref = bcvar.ref[match(variant1, bcvar.ref$rsid),]

gcdf = matrix(NA, nrow=nrow(bcvar.alt), ncol=4) # GC content data frame
for(i in 1:nrow(bcvar.alt)){
        bcvar.alt.bc = bcvar.alt$barcodes[i]
        bcvar.ref.bc = bcvar.ref$barcodes[i]
        
        bcvar.alt.bc = unlist(strsplit(bcvar.alt.bc, split=","))
        bcvar.ref.bc = unlist(strsplit(bcvar.ref.bc, split=","))
        gcperc.alt = (str_count(bcvar.alt.bc, pattern = "G") + str_count(bcvar.alt.bc, pattern = "C"))/20
        gcperc.ref = (str_count(bcvar.ref.bc, pattern = "G") + str_count(bcvar.ref.bc, pattern = "C"))/20
        
        tresult = t.test(gcperc.alt, gcperc.ref)
        wresult = wilcox.test(gcperc.alt, gcperc.ref)
        gcdf[i,3] = tresult$p.value
        gcdf[i,4] = wresult$p.value
        
        gcdf[i,1] = mean(gcperc.ref)
        gcdf[i,2] = mean(gcperc.alt)
        
        print(i)
}
colnames(gcdf) = c("alt", "ref", "t.test", "wilcox.test")
gcdf = data.frame(gcdf)
gcdf$variant = variant1
gcdf$fdr = p.adjust(gcdf$t.test, "BH")
t = t.test(gcdf[,1], gcdf[,2])
p.value = signif(as.numeric(unlist(t)[3]),3)
#wilcox.test(gcdf[,1], gcdf[,2]), double-check by assuming no distribution

# call GC content boxplot
pdf(paste0("GC_content.pdf"), height=5, width=5)
a = ggplot() +
        geom_boxplot(data=gcdf, aes(x="alt", y=alt), color="black") +
        geom_boxplot(data=gcdf, aes(x="ref", y=ref), color="grey25") +
        ylim(c(0.41,0.51)) +
        xlab("variant type") + ylab("GC content") +
        ggtitle("GC content and T-test (alt vs. ref)") + 
        geom_text(data=gcdf[gcdf$variant == "rs16887340",], aes(x="alt", y=0.4186, label="rs16887340")) +
        geom_text(data=gcdf[gcdf$variant == "rs16887340",], aes(x="ref", y=0.503, label="rs16887340")) +
        geom_text(data=gcdf[gcdf$variant == "rs12681501",], aes(x="ref", y=0.497, label="rs12681501")) +
        theme_bw()
a + annotate("text", x=1.5, y=0.51, label=paste0("P value=",p.value),3)
dev.off()

# Plot distribution of GC content for a specific variant
var2plot = "rs7001340"

bcvar.alt.bc = bcvar.alt[bcvar.alt$rsid==var2plot, "barcodes"]
bcvar.ref.bc = bcvar.ref[bcvar.ref$rsid==var2plot, "barcodes"]

bcvar.alt.bc = unlist(strsplit(bcvar.alt.bc, split=","))
bcvar.ref.bc = unlist(strsplit(bcvar.ref.bc, split=","))

gcperc.alt.bc = (str_count(bcvar.alt.bc, pattern = "G") + str_count(bcvar.alt.bc, pattern = "C"))/20
gcperc.ref.bc = (str_count(bcvar.ref.bc, pattern = "G") + str_count(bcvar.ref.bc, pattern = "C"))/20

t = t.test(gcperc.alt.bc, gcperc.ref.bc)
p.value = signif(as.numeric(unlist(t)[3]),3)
tv.alt.df = as.data.frame(gcperc.alt.bc)
colnames(tv.alt.df) = "alt"
tv.ref.df = as.data.frame(gcperc.ref.bc)
colnames(tv.ref.df) = "ref"

# Call GC content boxplot for top variant
pdf(paste0("GC_content_top_variant.pdf"), height=5, width=5)
a = ggplot() +
  geom_boxplot(tv.alt.df, mapping = aes(x="alt", y=alt), color="black") +
  geom_boxplot(tv.ref.df, mapping = aes(x="ref", y=ref), color="grey25") +
  xlab("variant type") + ylab("GC content") +
  ggtitle("GC content and T-test (rs7001340)") + 
  theme_bw()
a + annotate("text", x=1.5, y=0.7, label=paste0("P value=",p.value),3)
dev.off()

# Call GC content histogram for each variant's p-value
pdf(paste0("GC_content_all_variants.pdf"), height=5, width=5)
a = ggplot(gcdf, aes(x=t.test)) +
        geom_histogram(binwidth=0.04, fill="white", col="black") +
        xlim(c(0.01,1.01)) + ylim(c(0,8)) +
        xlab("p-value of all variants") + ylab("Frequency") +
        ggtitle("GC content and P-value (all variants)") + 
        theme_bw()
a + annotate("text", x=0.5, y=7, label=paste0("GC content coverage\nmin=",signif(min(gcdf$t.test),3), "\nmax=",signif(max(gcdf$t.test),3)),3)
dev.off()
