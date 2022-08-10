YOURDIR <-"/scratch/kjecha/ants/antcontam/Lasiusreads"
setwd(YOURDIR)

fr <- read.table("lasiusReads.txt", header = F)

for (i in fr){
  SAMP <- i[1]
    i <- na.omit(i)
    i <- paste(i,"/1", sep="")
  outfile <- as.data.frame(i)
  outfile = outfile[-1,]
print(SAMP)
setwd("/scratch/kjecha/ants/antcontam/Lasiusreads/IDS")
  write.table(outfile, paste(SAMP,"_ID.txt", sep=""), 
              append = FALSE, sep = " ", dec = ".",
              row.names = F , col.names = F, quote = F)
}


