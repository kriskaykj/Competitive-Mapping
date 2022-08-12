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

module load gcc/9.3.0
module load r/4.0.5
module load samtools/1.12

YOURDIR=/scratch/kjecha/ants/catgen/
gunzip $YOURDIR/bam/*.bam.gz
gunzip $YOURDIR/sam/cut/*.sam.gz
mkdir $YOURDIR/mapplots

#Create readable .sam file and remove sam file head (lines that start with @)
for filename in $YOURDIR/bam/*.bam; do 
	f=${filename%.bam}
	file=${f##*/}
	samtools view -h $filename > $YOURDIR/sam/$file.sam 
	grep -v "@" $YOURDIR/sam/$file.sam > $YOURDIR/sam/cut/$file.sam
	gzip $filename
	gzip $YOURDIR/sam/$file.sam
done

#Run the r script file
Rscript 3catgen.r

gzip $YOURDIR/sam/cut/*.sam
