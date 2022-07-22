#!/bin/bash

#Slurm options:

#SBATCH --partition=cpu
#SBATCH --time=0-02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=80GB
#SBATCH --job-name=scaf
#SBATCH --export=NONE
#SBATCH --mail-user kristine.jecha@unil.ch
#SBATCH --mail-type BEGIN,END,FAIL,TIME_LIMIT_50

#for FASTA in /scratch/kjecha/ants/contam_genomes/*.fasta; do
#	f=${FASTA%.fasta}
#	SPEC=${f##*/}
#	sed 's/>/& $SPEC_/' $FASTA > /scratch/kjecha/ants/catgen/$SPEC_name.fasta
#done

sed 's/>/& Bacillus_rossius_/' /scratch/kjecha/ants/contam_genomes/Bacillus_rossius.fasta >  /scratch/kjecha/ants/catgen/Bacillus_rossius_name.fasta
sed 's/>/& Camponotus_fallax_/' /scratch/kjecha/ants/contam_genomes/Camponotus_fallax.fasta >  /scratch/kjecha/ants/catgen/Camponotus_fallax_name.fasta
sed 's/>/& Lasius_alienus_/' /scratch/kjecha/ants/contam_genomes/Lasius_alienus.fasta >  /scratch/kjecha/ants/catgen/Lasius_alienus_name.fasta
sed 's/>/& Lasius_cf_spathepus_/' /scratch/kjecha/ants/contam_genomes/Lasius_cf_spathepus.fasta >  /scratch/kjecha/ants/catgen/Lasius_cf_spathepus_name.fasta
sed 's/>/& Lasius_flavus_s1_/' /scratch/kjecha/ants/contam_genomes/Lasius_flavus_s1.fasta >  /scratch/kjecha/ants/catgen/Lasius_flavus_s1_name.fasta
sed 's/>/& Lasius_flavus_s2_/' /scratch/kjecha/ants/contam_genomes/Lasius_flavus_s2.fasta >  /scratch/kjecha/ants/catgen/Lasius_flavus_s2_name.fasta
sed 's/>/& Lasius_fuliginosus_s1_/' /scratch/kjecha/ants/contam_genomes/Lasius_fuliginosus_s1.fasta >  /scratch/kjecha/ants/catgen/Lasius_fuliginosus_s1_name.fasta
sed 's/>/& Lasius_fuliginosus_s2_/' /scratch/kjecha/ants/contam_genomes/Lasius_fuliginosus_s2.fasta >  /scratch/kjecha/ants/catgen/Lasius_fuliginosus_s2_name.fasta
sed 's/>/& Lasius_neglectus_/' /scratch/kjecha/ants/contam_genomes/Lasius_neglectus.fasta >  /scratch/kjecha/ants/catgen/Lasius_neglectus_name.fasta
sed 's/>/& Lasius_niger_/' /scratch/kjecha/ants/contam_genomes/Lasius_niger.fasta >  /scratch/kjecha/ants/catgen/Lasius_niger_name.fasta
sed 's/>/& Linepithema_humile_/' /scratch/kjecha/ants/contam_genomes/Linepithema_humile.fasta >  /scratch/kjecha/ants/catgen/Linepithema_humile_name.fasta
sed 's/>/& Messor_barbarus_/' /scratch/kjecha/ants/contam_genomes/Messor_barbarus.fasta >  /scratch/kjecha/ants/catgen/Messor_barbarus_name.fasta
sed 's/>/& Messor_barbarusFlye_/' /scratch/kjecha/ants/contam_genomes/Messor_barbarusFlye.fasta >  /scratch/kjecha/ants/catgen/Messor_barbarusFlye_name.fasta
sed 's/>/& Messor_capitatus_/' /scratch/kjecha/ants/contam_genomes/Messor_capitatus.fasta >  /scratch/kjecha/ants/catgen/Messor_capitatus_name.fasta
sed 's/>/& Pseudolasius_sp_/' /scratch/kjecha/ants/contam_genomes/Pseudolasius_sp.fasta >  /scratch/kjecha/ants/catgen/Pseudolasius_sp_name.fasta
sed 's/>/& Solenopsis_fugax_/' /scratch/kjecha/ants/contam_genomes/Solenopsis_fugax.fasta >  /scratch/kjecha/ants/catgen/Solenopsis_fugax_name.fasta
sed 's/>/& Solenopsis_geminata_/' /scratch/kjecha/ants/contam_genomes/Solenopsis_geminata.fasta >  /scratch/kjecha/ants/catgen/Solenopsis_geminata_name.fasta
sed 's/>/& Solenopsis_invicta_/' /scratch/kjecha/ants/contam_genomes/Solenopsis_invicta.fasta >  /scratch/kjecha/ants/catgen/Solenopsis_invicta_name.fasta
sed 's/>/& Timema_douglasi_/' /scratch/kjecha/ants/contam_genomes/Timema_douglasi.fasta >  /scratch/kjecha/ants/catgen/Timema_douglasi_name.fasta
sed 's/>/& Triticum_aestivum_/' /scratch/kjecha/ants/contam_genomes/Triticum_aestivum.fasta >  /scratch/kjecha/ants/catgen/Triticum_aestivum_name.fasta



for FASTAN in /scratch/kjecha/ants/catgen/*_name.fasta; do
	grep ">" $FASTAN | head -1 >> /scratch/kjecha/ants/catgen/scafs.txt
done

cat *_name.fasta > /scratch/kjecha/ants/catgen/catgen.fasta