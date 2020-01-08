file=$1

awk '{OFS="\t"}{print $1, $2, $3, $4, $5, $6, $7, "population"}' ${file} |head -1 > ${file}.tsv


awk '{OFS="\t"}{print $1, $2, $3, $4, $5, $6, $7, $1}' ${file} |grep -v FID |perl -pe 's/\tSF.*$/\tThis study/;' >> ${file}.tsv
head ${file}.tsv


module load r
Rscript --verbose Script/PlotMDS_density.R ${file}.tsv


