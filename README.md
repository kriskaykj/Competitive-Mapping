# Competitive-Mapping :dna::ant:
Used to map potentially contaminated reads against potential contaminant genomes and filter out contaminated reads. For use on HPC cluster with bash scripts
---
## Inputs needed:
- List of contaminated sample IDs
- Directory of sample reads in .fq format
- Genomes of target and contaminate species in .fasta format  
  
!BE SURE TO **CHANGE `YOURDIR`** VARIABLE IN ALL `.sh` AND `.r` FILES TO YOUR WORKING DIRECTORY!   
As well as read(`supermap.sh`) and contaminated genome diretory path(`scafname.sh`). (Paths to be changed noted in script file)
  
---
### (Optional) Step 0: Run Competitive Mapping pipeline on multiple genra quickly  
Create folders named after each genus, copy in scripts 2-5 and change genus-specific directorie paths for each genus folder.   
- Script: `0multirun.sh`  (**!replace** YOURDIR to genome directory path)  
Example of run: `sbatch 0multirun.sh Myr 2`, this runs step 2supermap.sh from the Myr (Myrmica genus) folder

### Step 1: Add species name to their scaffold/chromosome names to distinguish and concatenate target+contaminant genomes  
- Input: target and contaminant genomes `GENOME.fasta`
- Script: `1scafname.sh`  (**!replace** GENDIR to genome directory path)
- Output: `scafs.txt` (to verify scaffold names have been changed)    
          `GENOME_name.fasta` (genome with new scaffold names)  
          `catgen.fasta` (fasta file of all genomes combined)  

### Step 2: Loop through contaminated samples to map against catgen.fasta with BWA mem   
- Input: `catgen.fasta`, list of contaminated read IDs(**!replace** `samps`), `$SAMPLE.fq.gz`(contaminated .fq files)
- Script: `2supermap.sh`
- Output: `catgen_$SAMPLE.bam` (.bam file made for each contaminated sample, labelled with sample ID name)  
         `catgen_flagstat.txt` (flagstat summary of all read mapping to verify it worked correctly)  
           
### Step 3: Convert .bam to .sam file and run R script to create plots of read mapping   
- Input:`catgen_$SAMPLE.bam`
- Script:`3catgen.sh`, `3catgen.r`  
- Output:`/sam/catgen_$SAMPLE.sam` (readable .sam output)  
        `/sam/cut/catgen_$SAMPLE.sam` (removed headers of file, leaving only data table)  
        `/mapplots/mapplot_$SAMPLE.jpeg` (.jpeg image of plot, showing the proportion of reads in that sample that mapped to each species' genome)  
        `mapplot_summary.jpeg` (.jpeg image of summary of all sample mapping)

 Exampe of mapplot_$SAMPLE.jpeg output looking for contamination in Lasius species  
![mapplot for read 564](mapplot_564.jpeg)  

Exampe of mapplot_summary.jpeg output looking for contamination in Lasius species of 3 ant species     
 (possible contamination by Formica)  
 
![summary of mapplots](mapplot_summary.jpeg)    

### Step 4: Create list of reads in each sample that map prefeably to the target species   
- Input: `/sam/cut/catgen_$SAMPLE.sam`
- Script: `4filterReads.sh`   
          `4filterReads.r` (**!replace** species names and target species)  
- Output: `targetReads.txt` (summary list of all clean reads in all contaminated samples)     
          `/IDS/$SAMPLE_ID.txt`(reformatted list of clean reads for each sample)   

### Step 5: Filter out reads that don't map to target species in sample files   
- Input:  `$SAMPLE.fq.gz`(contaminated .fq files)  
- Script: `5bbmap.sh` (**!replace** `OUT`, `IDDIR`, and `SAMP` path to directories)    
- Output:  `/Filtered/$SAMPLE.filtered.fq.gz` (.fq sample containing only clean/uncontaminated reads)   
           
#### You can now use these filtered FASTq files to perform genotype analyses!      
