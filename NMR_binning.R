setwd("/Users/gara009/OneDrive - PNNL/Desktop/Sawi NMR data")
rm(list=ls());graphics.off()

# install.packages("ggsignif")
#   install.packages("ggpubr")
#  install.packages("ggplot")
#  install.packages("devtools")
#  install.packages("pracma")
#  install.packages("sfsmisc")
# install.packages("Bolstad2")
# install.packages("dplyr")
library(dplyr)
library(bindrcpp)
library(ggplot2)
library(ggsignif)
library(ggpubr)
library(dplyr)
library(reshape2)
library(ggpmisc)
library(segmented)
library(broom)
library(ggplot2)
library(dplyr)
library(devtools)
library(ggpmisc)
library(segmented)
library(pracma) #For trapz integration 
library(sfsmisc) #not good for noisy data
library(Bolstad2) #for Simpson's integration
library(MESS) #for integration with s
library(tidyr)

#load sample pre-processed (baseline corrected, phase adjusted, water peak removed 
#standard referenced) in x,y format

#list files in path, parse to only ones with "NMR" in name
read.from.path = "/Users/gara009/OneDrive - PNNL/Desktop/Sawi NMR data"
NMR.files = list.files(path = read.from.path)[grep(pattern = "NMR.csv",
x = list.files(path = read.from.path))]

outdata=data.frame(matrix(NA, nrow = 16, ncol =length(NMR.files) ))
#loop set up
for (j in 1:length(NMR.files)){
  #read in file number j into temp variable
  df = read.csv(NMR.files[j])
  #do whatever you want here

#df<- read.csv("12C_G_Day2_NMR.csv") #reads all the data from all treatments

#Calculate bins based on different papers

#Calculate bin integrals based on Lynch et al. 2019
#Lynch et al. "Dissolved organic matter chemistry and transport along an Arctic tundra hillslope."
#bin1= 0.6-1.6 ppm	methyl, methylene, and methane bearing protons
#1.6-3.2 ppm	unsaturated functional groups, including ketone, benzylic, and allylic-bearing protons
#3.2-4.5 ppm	unsaturated, heteroatomic compounds, including O-bearing carbohydrates, ethers, and alcohols
#6.5-8.5 ppm	conjugated, double bond functionalities, including aromatic, amide, and phenolic structures

df1 <- df[df$x >= 0.6 & df$x < 1.6, ]
bin1L=trapz(df1$x,df1$y)

df2 <- df[df$x >= 1.6 & df$x <= 3.2, ]
bin2L=trapz(df2$x,df2$y)

df3 <- df[df$x >= 3.2 & df$x <= 4.5, ]
bin3L=trapz(df3$x,df3$y)

df4 <- df[df$x >= 6.5 & df$x <= 8.5, ]
bin4L=trapz(df4$x,df4$y)

totalbinL=sum(bin1L,bin2L,bin3L,bin4L)

Bin1L=(bin1L/totalbinL)*100
Bin2L=(bin2L/totalbinL)*100
Bin3L=(bin3L/totalbinL)*100
Bin4L=(bin4L/totalbinL)*100

Lynch=rbind("0.6-1.6ppm" = Bin1L, "1.6-3.2ppm" = Bin2L, "3.2-4.5ppm"= Bin3L, "6.5-8.5ppm" = Bin4L)

#Calculate integral bins based on Mitchell et al., 2018
#Mitchell, Perry, et al. "Nuclear magnetic resonance analysis of changes in dissolved organic matter composition with successive layering on clay mineral surfaces."Soil Systems 2.1 (2018): 8.
#0.6-1.3 ppm	aliphatic polymethylene and methyl groups
#1.3-2.9 ppm	N- and O-substituted aliphatic
#2.9-4.1 ppm	O-alkyl 
#4.1-4.8 ppm	proton of peptides
#4.8-5.2 ppm	anomeric proton of carbohydrates
#6.2-7.8 ppm	aromatic and phenolic

df1 <- df[df$x >= 0.6 & df$x < 1.3, ]
bin1M=trapz(df1$x,df1$y)

df2 <- df[df$x >= 1.3 & df$x <= 2.9, ]
bin2M=trapz(df2$x,df2$y)

df3 <- df[df$x >= 2.9 & df$x <= 4.1, ]
bin3M=trapz(df3$x,df3$y)

df4 <- df[df$x >= 4.1 & df$x <= 4.8, ]
bin4M=trapz(df4$x,df4$y)

df5 <- df[df$x >= 4.8 & df$x <= 5.2, ]
bin5M=trapz(df5$x,df5$y)

df6 <- df[df$x >= 6.2 & df$x <= 7.8, ]
bin6M=trapz(df6$x,df6$y)

df7 <- df[df$x >= 7.8 & df$x <= 8.4, ]
bin7M=trapz(df7$x,df7$y)

totalbinM=sum(bin1M,bin2M,bin3M,bin4M,bin5M,bin6M,bin7M)

Bin1M=(bin1M/totalbinM)*100
Bin2M=(bin2M/totalbinM)*100
Bin3M=(bin3M/totalbinM)*100
Bin4M=(bin4M/totalbinM)*100
Bin5M=(bin5M/totalbinM)*100
Bin6M=(bin6M/totalbinM)*100
Bin7M=(bin7M/totalbinM)*100

Mitchell=rbind("0.6-1.3ppm" = Bin1M, "1.3-2.9ppm" = Bin2M, "2.9-4.1ppm"= Bin3M, "4.1-4.8ppm" = Bin4M, "4.8-5.2ppm" = Bin5M, "6.2-7.8ppm" = Bin6M, "7.8-8.4ppm" = Bin7M)


#Calculate integrals based on Hertkorn et al 2017
#Li et al., Proposed Guidelines for Solid Phase Extraction of Suwannee River Dissolved Organic Matter
#0.5-1.95ppm CCCH aliphatics
#1.95-3.1ppm XCCH carboxylic rich aromatic molecules
#3.6-4.9ppm carbohydrate and methoxy groups region 
#5.3-7.0ppm Common aromatic molecules
#7-9.5ppm

df1 <- df[df$x >= 0.5 & df$x < 1.9, ]
bin1H=trapz(df1$x,df1$y)

df2 <- df[df$x >= 1.9 & df$x <= 3.1, ]
bin2H=trapz(df2$x,df2$y)

df3 <- df[df$x >= 3.6 & df$x <= 4.9, ]
bin3H=trapz(df3$x,df3$y)

df4 <- df[df$x >= 5.3 & df$x <= 7.0, ]
bin4H=trapz(df4$x,df4$y)

df5 <- df[df$x >= 7.0 & df$x <= 9.5, ]
bin5H=trapz(df5$x,df5$y)

totalbinH=sum(bin1H,bin2H,bin3H,bin4H,bin5H)

Bin1H=(bin1H/totalbinH)*100
Bin2H=(bin2H/totalbinH)*100
Bin3H=(bin3H/totalbinH)*100
Bin4H=(bin4H/totalbinH)*100
Bin5H=(bin5H/totalbinH)*100

Hertk=rbind("0.5-1.9ppm" = Bin1H, "1.9-3.1ppm" = Bin2H, "3.6-4.9ppm"= Bin3H, "5.3-7ppm" = Bin4H, "7-9.5ppm" = Bin5H)


test=rbind(Lynch,Mitchell,Hertk)
outdata[j]=as.data.frame(rbind(Lynch,Mitchell,Hertk))
names(outdata)[j]= paste(NMR.files[j])
rownames(outdata)=row.names(test)
}

write.csv(outdata,"NMR_Bins_Sawi_Priming_experiment.csv")
