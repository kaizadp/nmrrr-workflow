###### NMRRR - NMR RESULTS WITH R
###### KAIZAD F. PATEL, 2020
###### SCRIPT 1: NMR PEAKS

## USE THIS SCRIPT TO PROCESS PEAK FILES AND PLOT SPECTRA

# ----------------------------------------- - - -

# PART I. LOAD THE PARAMETERS ----
source("0-nmr_spectra_setup.R")

#
# PART II. LOAD NMR SPECTRA FILES ----

# import all .csv files in the target folder 

filePaths <- list.files(path = "data/spectra/",pattern = "*.csv", full.names = TRUE)

spectra <- do.call(rbind, lapply(filePaths, function(path) {
# the files are tab-delimited, so read.csv will not work. import using read.table
# there is no header. so create new column names
# then add a new column `source` to denote the file name
    df <- read.table(path, header=FALSE, col.names = c("ppm", "intensity"))
    df[["source"]] <- rep(path, nrow(df))
    df}))
  

# CLEANING
spectra2 = 
  spectra %>% 
# retain only values 0-10ppm
  filter(ppm>=0&ppm<=10)  
# remove water and DMSO regions
#  filter(!(ppm>DMSO_start&ppm<WATER_stop)) %>%  
#  filter(!(ppm>DMSO_start&ppm<DMSO_stop))

#

# PART III. PLOT THE SPECTRA ----
## using gg_nmr1
gg_nmr1+
  geom_path(data = spectra2, aes(x = ppm, y = intensity, color = source))+
  ylim(0,3)
ggsave("images/spectra_1.png", width = 10, height = 4)

## using gg_nmr2
gg_nmr2+
  geom_path(data = spectra2, aes(x = ppm, y = intensity, color = source))+
  ylim(0,3)
ggsave("images/spectra_2.png", width = 10, height = 4)
