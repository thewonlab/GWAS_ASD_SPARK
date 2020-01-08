#!/bin/bash

### Script to run PRSise

SUMSTAT=$1
NAME=$2
BASE_FOLDER=$3
TARGET=$4

echo $SUMSTAT
echo $NAME
echo $BASE_FOLDER

### BEGIN SCRIPT

cd $BASE_FOLDER
pwd

PRS_PATH_binary="/nas/longleaf/home/nanam/pkg/PRSice/2.2.6/PRSice_linux"

module load r/3.5.0
${PRS_PATH_binary} \
--A1 A1 \
--A2 A2 \
--all-score  \
--bar-levels 0.00000005,0.000001,0.0001,0.001,0.01,0.05,0.1,0.2,0.5,1 \
--base ${SUMSTAT} \
--binary-target T \
--bp BP \
--chr CHR \
--clump-kb 250 \
--clump-p 1.000000 \
--clump-r2 0.100000 \
--fastscore  \
--ld ../../../03PRSinput/Ref/1000GEUR/ALL.GRCh38.genotypes.20170504.EUR \
--missing MEAN_IMPUTE \
--model add \
--no-regress  \
--or  \
--out ${NAME} \
--pvalue P \
--score asd \
--seed 725339199 \
--snp SNP \
--stat OR \
--target ${TARGET} \
--memory 50gb \
--thread 1
#--print-snp \
