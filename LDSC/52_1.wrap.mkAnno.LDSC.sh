
for i in 50LDSC/dataset/GZ_CP_diff_NMatched;do
for chr in `seq 1 22`;do
 sbatch -n 1 -o ${i}/${chr}.slurm.log --mem-per-cpu=40g Script/mkAnno.LDSC.sh ${chr} ${i}
done
done
