


## This function will create a plot of NMR spectra, with line-brackets denoting binned regions
gg_spectra = function(dat, LABEL_POSITION, mapping, STAGGER){
  
  # create spectra-base plot ----
  
  spectra_base = 
    ggplot()+
    # stagger bracketing lines for odd vs. even rows  
    geom_segment(data=bins_dat %>% dplyr::filter(row_number() %% 2 == 0), 
                 aes(x=start, xend=stop, y=LABEL_POSITION, yend=LABEL_POSITION), color = "black")+
    geom_segment(data=bins_dat %>% dplyr::filter(row_number() %% 2 == 1), 
                 aes(x=start, xend=stop, y=LABEL_POSITION-0.2, yend=LABEL_POSITION-0.2), color = "black")+
    # stagger numbering like the lines
    geom_text(data=bins_dat %>% dplyr::filter(row_number() %% 2 == 0), 
              aes(x = (start+stop)/2, y = LABEL_POSITION+0.1, label = number))+
    geom_text(data=bins_dat %>% dplyr::filter(row_number() %% 2 == 1), 
              aes(x = (start+stop)/2, y = LABEL_POSITION-0.1, label = number))+
    scale_x_reverse(limits = c(10,0))+
    
    #geom_path(data = dat, aes(x = ppm, y = intensity, color = source))+
    xlab("shift, ppm")+
    ylab("intensity")+
    theme_classic()
  
  # add staggering factor ----
  
  stagger_factor = 1/STAGGER
  dat_y_stagger = 
    dat %>% 
    distinct(source) %>% 
    mutate(newsource = source != c(NA, head(source, -1))) %>% 
    drop_na() %>% 
    mutate(y_factor = cumsum(newsource)/stagger_factor) %>% 
    dplyr::select(source, y_factor)
  
  spectra_new = 
    dat %>% 
    left_join(dat_y_stagger) %>% 
    replace_na(list(y_factor = 0)) %>% 
    mutate(intensity_new = intensity + y_factor) %>% 
    dplyr::select(-intensity) %>% 
    rename(intensity = intensity_new)
  
  # combined plot ----
  
  spectra_base+
    geom_path(data = spectra_new, mapping)
  
}


