#!/usr/bin/bash
#SBATCH -o 40POO/20190730/poo_chr%a.log

outdir="40POO/20190730"
gwasdir="20GWAS/201905/trio_4"

chr=${SLURM_ARRAY_TASK_ID}
rsidfile="02IMPUTATION/imputed/20190423/20190530/trios/chr${chr}.pos.id.tsv"
pgen="02IMPUTATION/imputed/20190423/20190624/plink/chr${chr}_HDS"

model="model1"
skip=1

if [[ skip -eq 0 ]]; then
 for i in `grep T ${gwasdir}/plink/20190423_20190503v1_model1.final.indiv|cut -d" " -f1|sort|uniq`;do
  #~/ongoing/conf/20190423_20190530.family
  #FID	IID	PID	MID
  grep $i ~/ongoing/conf/20190423_20190530.family|awk '{print $1,$1"_"$2"-U",$1"_"$3,$1"_"$4}' >> ${outdir}/${model}_familyInfo.txt
  #~/ongoing/conf/20190423_20190530.sex
  #FID	IID	SEX(1 or 2)
  grep $i ~/ongoing/conf/20190423_20190530.sex|awk '{print $1,$1"_"$2,$3}' >> ${outdir}/${model}_ParentsSexInfo.txt
  #~/ongoing/conf/20190423_20190530.pheno
  #FID	IID	ASD(1 or 2)
  grep $i ~/ongoing/conf/20190423_20190530.pheno|awk '{print $1,$1"_"$2,$3}' >> ${outdir}/${model}_Pheno.txt
done

fi

module load plink/2.00a-20190527

plink2 --pgen ${pgen}.pgen --psam ${gwasdir}/plink/20190423_20190624.psam --pvar ${pgen}.pvar --minimac3-r2-filter 0.9 --maf 0.01 minor --keep ${outdir}/${model}_samplelist --update-parents ${outdir}/${model}_familyInfo.txt --update-sex ${outdir}/${model}_ParentsSexInfo.txt --ref-allele ${rsidfile} 4 6 --make-bed --out ${outdir}/chr${chr}.imputed_${model}

module load r/3.5.0 
Rscript Script/40_1.UpdateParentPhenoForPOO.R ${outdir}/chr${chr}.imputed_${model}.fam

