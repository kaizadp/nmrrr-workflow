
# -------------------------------------------------------------------------
# formatting the input files to make a long-form dataframe

rawdat <- read.csv("data/peaks/27.csv", stringsAsFactors = FALSE, check.names = FALSE)

# The raw NMR data are in groups of nine columns, with the first column in the group
# (the observation number) having no name. Start by finding these no-name columns and 
# verifying they're exactly 9 positions part; otherwise we have a problem
noname_cols <- which(names(rawdat) == "")
if(!all(diff(noname_cols) == 9)) {
  stop("Formatting problem: data don't appear to be in 9-column groups")
}
names(rawdat)[noname_cols] <- "Obs"  # give them a name

# Extract each group in turn and store temporarily in a list
nmr_list <- list()
for(nnc in seq_along(noname_cols)) {
  nmr_list[[nnc]] <- rawdat[nnc:(nnc + 8)]
}

# Finally, bind everything into a single data frame
# This uses dplyr but we could also use base R: do.call("rbind", nmr_list)
nmr_dat <- dplyr::bind_rows(nmr_list)
