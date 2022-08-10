#!/bin/bash

#Slurm options:

#SBATCH --partition=cpu
#SBATCH --time=3-0:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=80GB
#SBATCH --job-name=BBMAP
#SBATCH --export=NONE
#SBATCH --mail-user kristine.jecha@unil.ch
#SBATCH --mail-type BEGIN,END,FAIL,TIME_LIMIT_50

module load gcc/9.3.0
module load r/4.0.5
module load bbmap/38.63


OUT=/scratch/kjecha/ants/antcontam/Lasiusreads/Lasfiltered/
IDDIR=/scratch/kjecha/ants/antcontam/Lasiusreads/IDS/
SAMP=/work/FAC/FBM/DEE/tschwand/operation_fourmis/glavanc1/Lasius/clean/

#Rscript idlist.R


for filename in $IDDIR/*.txt; do 
	f=${filename%_ID.txt}
	file=${f##*/}
	filterbyname.sh in=$SAMP/$file.fq.gz names=$filename out=$OUT/$file.filtered.fq.gz include=t

done


#THERE ARE DUPLICATES IN ID.TXT BECAUSE THERE ARE DUPLICATES IN .SAM FILE, IE 1 READ MAPPED TO MULTIPLE PLACES
# but filterbyname only keeps it once so OK