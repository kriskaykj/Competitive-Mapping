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

gunzip /scratch/kjecha/ants/catgen/bam/*.bam.gz
gunzip /scratch/kjecha/ants/catgen/sam/cut/*.sam.gz

mkdir /scratch/kjecha/ants/catgen/sam/cut

for filename in /scratch/kjecha/ants/catgen/bam/*.bam; do 
	f=${filename%.bam}
	file=${f##*/}
	samtools view -h $filename > /scratch/kjecha/ants/catgen/sam/$file.sam 
	grep -v "@" /scratch/kjecha/ants/catgen/sam/$file.sam > /scratch/kjecha/ants/catgen/sam/cut/$file.sam
	gzip $filename
	gzip /scratch/kjecha/ants/catgen/sam/$file.sam
done

Rscript catgen.r

gzip /scratch/kjecha/ants/catgen/sam/cut/*.sam
