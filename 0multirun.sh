#!/bin/bash

#Slurm options:

#SBATCH --partition=cpu
#SBATCH --time=0-00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=80GB
#SBATCH --job-name=run
#SBATCH --export=NONE
#SBATCH --mail-user @unil.ch
#SBATCH --mail-type BEGIN,END,FAIL,TIME_LIMIT_50

# This can be used if you have multiple genera to decontaminate at once. Create a folder within you main competitive mapping directory for each genus
# Run slurm script by writing "sbatch 0multirun.sh Myr 2"
# Myr is a folder for the files of the Myrmica genus, 2 is the 2nd step of the pipeline (the supermap step)

YOURDIR=/work/FAC/FBM/DEE/tschwand/operation_fourmis/kjecha/AllGenusCompetitive-Mapping

echo "Genus: $1, Step: $2"

if [ $2 == 2 ]; then
sbatch $YOURDIR/$1/2supermap.sh
 elif [ $2 == 3 ]; then
sbatch /$1/3catgen.sh
elif [ $2 == 4 ]; then
sbatch /$1/4filterReads.sh
elif [ $2 == 5 ]; then
sbatch /$1/5bbmap.sh
else
echo "Choose step 2-5"
fi
