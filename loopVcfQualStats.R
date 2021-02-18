# tells R to take arguments from bash script 
args=commandArgs(trailingOnly=TRUE)

library("vcfR")

# List of VCF files for R to loop through 
vcfList<-read.table(args[1], header=F)
# Require a character vector
vcfList2<-vcfList[,]

# create three emoty data frames
df1 = NULL
df2 = NULL
df3 = NULL


for (i in vcfList2)
{
rm(vcf)
rm(chrom)
vcf <- read.vcfR(i, verbose = FALSE)
chrom <- create.chromR(name='chromosome', vcf=vcf)

# get descriptive stats for MQ
meanMQ<-round(mean(chrom@var.info$MQ),0)
sdMQ<-round(sd(chrom@var.info$MQ),0)
minMQ<-round(min(chrom@var.info$MQ),0)
maxMQ<-round(max(chrom@var.info$MQ),0)
chromNum<-chrom@vcf@fix[1,1]
# append results to data frame (df1)
df1<-rbind(df1, data.frame(chromNum,meanMQ,sdMQ,minMQ,maxMQ))

# MQ
meanDP<-round(mean(chrom@var.info$DP),0)
sdDP<-round(sd(chrom@var.info$DP),0)
minDP<-round(min(chrom@var.info$DP),0)
maxDP<-round(max(chrom@var.info$DP),0)
df2 <- rbind(df2, data.frame(meanDP,sdDP,minDP,maxDP))

# QUAL
quality<-as.numeric(chrom@vcf@fix[,6])
meanQUAL<-round(mean(quality),0)
sdQUAL<-round(sd(quality),0)
minQUAL<-round(min(quality),0)
maxQUAL<-round(max(quality),0)
df3<-rbind(df3, data.frame(meanQUAL,sdQUAL,minQUAL,maxQUAL))
}

mergeAll<-cbind(df1,df2,df3)

#write results to file 
write.table(margeAll,args[2],quotes=F)


# Run in Linux using command 
# Rscript sysTime.R $input $output
# set a lot of memory! 
