

# STEP 0: load packages ---------------------------------------------------
library(tidyverse)
library(readxl)

# STEP 1: source functions ------------------------------------------------
source("code/functions_processing.R")
source("code/functions_graphs.R")


# STEP 1b. set bins -------------------------------------------------------
## choose which set of BINS SET to use
cat("ACTION: choose correct value of BINSET
      a.> Clemente2012
      b.> Lynch2019
      c.> Mitchell2018
  type this into the code
  e.g.: BINSET = [quot]Clemente2012[quot]")

BINSET = "Clemente2012"
bins_dat = set_bins(BINSET)

# STEP 2: set input directories -------------------------------------------
SPECTRA_FILES = "data/spectra/"
PEAKS_FILES = "data/peaks/"

# STEP 3: process spectra and peak data -----------------------------------
spectra_processed = import_nmr_spectra_data(SPECTRA_FILES = "data/spectra/")
peaks_processed = import_nmr_peaks(PEAKS_FILES = "data/peaks/")

# STEP 4: graphs ----------------------------------------------------------
gg_spectra(dat = spectra_processed, 
           LABEL_POSITION = 3, 
           aes(x = ppm, y = intensity, group = source, color = source),
           STAGGER = 0.5) + 
  labs(subtitle = paste("binset:", BINSET))+
  ylim(0, 3.5)



