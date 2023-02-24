#!/bin/bash

#Slurm options:

#SBATCH --partition=cpu
#SBATCH --time=0-4:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=80GB
#SBATCH --job-name=Rplot
#SBATCH --export=NONE
#SBATCH --mail-user @unil.ch
#SBATCH --mail-type BEGIN,END,FAIL,TIME_LIMIT_50

module load gcc
module load r
module load samtools

YOURDIR=/scratch/kjecha/ants/catgen/

gunzip $YOURDIR/sam/cut/*.sam.gz

#Create readable .sam file and remove sam file head (lines that start with @)
for filename in $YOURDIR/sam/*.sam; do 
	f=${filename%.sam}
	file=${f##*/}
	grep -v "@" $YOURDIR/sam/$file.sam > $YOURDIR/sam/cut/$file.sam
	gzip $filename
done

#Run the r script file
Rscript 3catgen.r

gzip $YOURDIR/sam/cut/*.sam
