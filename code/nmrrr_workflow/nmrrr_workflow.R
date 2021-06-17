

# STEP 0: load packages ---------------------------------------------------
library(tidyverse)
library(readxl)

# STEP 1: source functions ------------------------------------------------
source("code/nmrrr_workflow/1-functions_processing.R")
source("code/nmrrr_workflow/3-functions_graphs.R")
source("code/nmrrr_workflow/2-functions_relabund.R")
source("code/nmrrr_workflow/4-functions_stats.R")


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

# STEP 4: spectra graphs ----------------------------------------------------------
gg_spectra(dat = spectra_processed, 
           LABEL_POSITION = 3, 
           aes(x = ppm, y = intensity, group = source, color = source),
           STAGGER = 0.5) + 
  labs(subtitle = paste("binset:", BINSET))+
  ylim(0, 3.5)


# STEP 5: relative abundance ---------------------------

## 5a. load corekey
COREKEY = "data/corekey.csv"
corekey = read.csv(COREKEY) %>% mutate(Core = as.character(Core))

## 5b. set treatments
TREATMENTS = quos(treatment)

## 5c. compute and plot relabund
relabund_cores = compute_relabund_cores(peaks_processed, bins_dat, corekey)
relabund_summary = compute_relabund_summary(relabund_cores, TREATMENTS)
relabund_summarytable = compute_relabund_summarytable(relabund_summary)
relabund_bar = plot_relabund_bargraphs(relabund_summary, TREATMENTS)


# STEP 6: statistics ------------------------------------------------------
# these functions are designed specifically for this test dataset, needs tweaking

compute_nmr_permanova(relabund_cores)
compute_fticr_pca(relabund_cores)

