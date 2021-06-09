

# I. NMR BINS -------------------------------------------------------------
set_bins = function(BINSET){
  filePath_bins <- list.files(path = "bins", pattern = BINSET, full.names = TRUE)
  read.delim(filePath_bins, header = TRUE) %>% 
    arrange(start) %>% 
    dplyr::mutate(number = row_number())
}


#
# I. NMR SPECTRA ----------------------------------------------------------
# this function will import NMR spectra data, combine, and clean 
import_nmr_spectra_data = function(SPECTRA_FILES){
  filePaths_spectra <- list.files(path = SPECTRA_FILES,pattern = "*.csv", full.names = TRUE)
  spectra_dat <- do.call(rbind, lapply(filePaths_spectra, function(path) {
    # the files are tab-delimited, so read.csv will not work. import using read.table
    # there is no header. so create new column names
    # then add a new column `source` to denote the file name
    df <- read.table(path, header=FALSE, col.names = c("ppm", "intensity"))
    df[["source"]] <- rep(path, nrow(df))
    df}))
  
  process_spectra_data = function(spectra_dat){
    spectra_dat %>% 
      # retain only values 0-10ppm
      filter(ppm >= 0 & ppm <= 10) %>% 
      mutate(source = str_remove(source, paste0(SPECTRA_FILES, "/"))) %>% 
      mutate(source = str_remove(source, ".csv")) %>% 
      # mutate(source = paste0("DOC-",source)) %>% 
      # dplyr::rename(DOC_ID = source) %>% 
      # left_join(doc_key, by = "DOC_ID") %>% 
      force()
  }
  process_spectra_data(spectra_dat)
}



# II. NMR PEAKS -----------------------------------------------------------
# this function will import NMR peaks data, align and combine, 
# and then process and clean the dataset.
import_nmr_peaks = function(PEAKS_FILES){
  filePaths_peaks <- list.files(path = PEAKS_FILES,pattern = "*.csv", full.names = TRUE)
  peaks_rawdat <- do.call(bind_rows, lapply(filePaths_peaks, function(path) {
    # this function will import all the data files and combine for all samples
    # first, we run the function to clean a single file
    # the input data are spread across multiple columns, so use this function to align columns
    
    align_columns = function(path){
      # Step 1. import file. 
      # check.names=FALSE because columns have duplicate names, and we want to leave as is
      df <- read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
      
      # Step 2. confirm that the data are in 9-column groups
      noname_cols <- which(names(df) == "")
      if(!all(diff(noname_cols) == 9)) {
        stop("Formatting problem: data don't appear to be in 9-column groups")
      }
      names(df)[noname_cols] <- "Obs"  # give them a name
      
      # Step 3. Extract each group in turn and store temporarily in a list
      nmr_list <- lapply(noname_cols, function(x) df[x:(x + 8)])
      
      # Step 4. Finally, bind everything into a single data frame
      # This uses dplyr but we could also use base R: do.call("rbind", nmr_list)
      nmr_dat <- dplyr::bind_rows(nmr_list)
      
      # Step 5. Create a new column that includes source sample name
      nmr_dat[["source"]] <- rep(path, nrow(df))
      
      nmr_dat
    }
    
    # now create an object from the function
    align_columns(path)
    # this will be repeated for each file in the input folder
    
  }))
  
  # process the dataset
  process_peaks_data = function(peaks_rawdat){
    # WATER_start = 3; WATER_stop = 4
    # DMSO_start = 2.25; DMSO_stop = 2.75
    
    peaks_rawdat %>% 
      filter(ppm>=0&ppm<=10) %>% 
      filter(Intensity > 0) %>% 
      # remove solvent regions
      #filter(!(ppm>DMSO_start & ppm<DMSO_stop)) %>% 
      #filter(!(ppm>WATER_start & ppm<WATER_stop)) %>% 
      filter(!is.na(ppm)) %>% 
      # remove peaks with 0 intensity, and peaks flagged as weak 
      filter(!Flags=="Weak") %>% 
      mutate(source = str_remove(source, paste0(PEAKS_FILES, "/"))) %>% 
      mutate(source = str_remove(source, ".csv")) %>% 
      #mutate(DOC_ID = paste0("DOC-", DOC_ID)) %>% 
      #dplyr::select(-Obs, -source) %>% 
      dplyr::select(-Obs) %>% 
      force()
  }
  process_peaks_data(peaks_rawdat)
}




