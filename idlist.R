YOURDIR <-"/scratch/kjecha/ants/antcontam/Lasiusreads"
setwd(YOURDIR)

fr <- read.table("targetReads.txt", header = F)

#Split up targetReads.txt table by column, creating an individual file for each sample with all correctly mapping reads
for (i in fr){
  SAMP <- i[1]
    i <- na.omit(i)
    i <- paste(i,"/1", sep="")
  outfile <- as.data.frame(i)
  outfile = outfile[-1,]
print(SAMP)
setwd(paste(YOURDIR, "/IDS", sep=""))
  write.table(outfile, paste(SAMP,"_ID.txt", sep=""), 
              append = FALSE, sep = " ", dec = ".",
              row.names = F , col.names = F, quote = F)
}


