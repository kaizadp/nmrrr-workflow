

# Part I. Calculate relative abundance ------------------------------------

compute_relabund_cores = function(peaks_processed, bins_dat, corekey){
  rel_abund_cores1 = 
    peaks_processed %>% 
    #subset(merge(peaks_processed, bins_dat), start <= ppm & ppm <= stop) %>% 
    #dplyr::select(source,ppm, Area, group) %>% 
    #filter(!(ppm>DMSO_start&ppm<DMSO_stop)) %>% 
    rename(Core = source) %>% 
    group_by(Core, group) %>% 
    #filter(group != "oalkyl") %>% 
    dplyr::summarize(area = sum(Area)) %>% 
    group_by(Core) %>% 
    dplyr::mutate(total = sum(area),
                  relabund = round((area/total)*100,2)) %>% 
    dplyr::select(Core, group, relabund) %>% 
    replace(is.na(.), 0) %>% 
    left_join(corekey, by = "Core")
  
  rel_abund_wide1 = 
    rel_abund_cores1 %>% 
    pivot_wider(names_from = "group", values_from = "relabund")
  
  (rel_abund_cores = 
    rel_abund_wide1 %>% 
    pivot_longer(where(is.numeric), values_to = "relabund", names_to = "group") %>% 
    replace_na(list(relabund = 0)))
}
compute_relabund_summary = function(relabund_cores, TRT){
  (relabund_summary = 
    relabund_cores %>%
    group_by(group, !!!TRT) %>% 
    dplyr::summarize(relabund_mean = round(mean(relabund),2),
                     relabund_se = round(sd(relabund, na.rm = T)/sqrt(n()), 2))) 
}
compute_relabund_summarytable = function(relabund_summary){
  (relabund_summarytable = 
    relabund_summary %>% 
    mutate(relabund = paste(relabund_mean, "\u00b1", relabund_se),
           relabund = str_remove_all(relabund, " \u00b1 NA"))) 
}
plot_relabund_bargraphs = function(relabund_summary, TRT){
  (relabund_bar = 
    relabund_summary %>% 
    ggplot(aes(x = interaction(!!!TRT), y = relabund_mean, fill = group))+
    geom_bar(stat = "identity")+
#    facet_grid(~ treatment)+
  theme_classic()+
    NULL)
}

compute_relabund_cores_by_auc = function(bins_dat, spectra_processed){
  ## computing relative abundance, type 2
  ## using area under the curve from the spectra
  
  bins_dat2 = 
    bins_dat %>% 
    dplyr::select(group, start, stop)
  
  spectra_group = subset(merge(spectra_processed, bins_dat2), start <= ppm & ppm <= stop) %>% 
    dplyr::select(-start, -stop)
  
  spectra_group %>% 
    group_by(source, group) %>% 
    dplyr::summarise(AUC = DescTools::AUC(x = ppm, y = intensity, 
                               from = min(ppm), to = max(ppm)),
                     method = "trapezoid") %>% 
    mutate(total = sum(AUC),
           relabund = (AUC/total)*100)
  
}