install.packages("speaq")   
library(speaq)

library("devtools")
install_github("beirnaert/speaq")
library("speaq")

spectra.matrix = as.matrix(Winedata$spectra)

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("MassSpecWavelet")


if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("impute")

################
library(dplyr)
library(speaq)

spectra.dt = as.data.frame(Winedata$spectra)
ppm.dt = as.data.frame(Winedata$ppm)
class.dt = as.data.frame(Winedata$wine.color)

wine.dt = 
  ppm.dt %>% 
  rbind(class.dt)


# get the data. (spectra in matrix format)
spectra.matrix = as.matrix(Winedata$spectra)
ppm.vector = as.numeric(Winedata$ppm)
class.factor = as.factor(Winedata$wine.color)

# plot the spectra
drawSpecPPM(Y.spec = spectra.matrix, X.ppm = ppm.vector,  title = 'Example spectra')

# peak detection (the default mode is parallel)
peaks <- getWaveletPeaks(Y.spec = spectra.matrix, X.ppm = ppm.vector)  

# peak grouping
groups <- PeakGrouper(Y.peaks = peaks)

# get the feature matrix
Features <- BuildFeatureMatrix(Y.data = groups)

# this featurematrix can be processed further (scaling, transformations) or 
# analysed with the statistical tools of interest like PCA. 