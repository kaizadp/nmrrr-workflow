
source("0-nmr_setup.R")


# I. LOAD FILES ----
peaks = read.csv(PROCESSED_PEAKS, stringsAsFactors = F)
corekey = read.csv(COREKEY)


# II. CALCULATE RELATIVE ABUNUDANCE ----
## calculate relative abundance of groups in each core

rel_abund = 
  subset(merge(peaks, bins2), start <= ppm & ppm <= stop) %>% 
  #dplyr::select(source,ppm, Area, group) %>% 
  #filter(!(ppm>DMSO_start&ppm<DMSO_stop)) %>% 
  group_by(Core, group) %>% 
  dplyr::summarize(area = sum(Area)) %>% 
  group_by(Core) %>% 
  dplyr::mutate(total = sum(area),
                relabund = round((area/total)*100,2)) %>% 
  dplyr::select(Core, group, relabund) %>% 
  spread(group, relabund) %>% 
  melt(id="Core", variable.name = "group", value.name = "relabund") %>% 
  replace(is.na(.), 0) %>% 
  left_join(corekey, by = "Core") %>% 
  ungroup()
  

#


## relative abundance by treatment
rel_abund_trt = 
  rel_abund %>% 
  group_by(group, treatment) %>% 
  dplyr::summarise(rel_abund = round(mean(relabund, na.rm=TRUE),2),
                   se = round(sd(relabund)/sqrt(n()),2)) %>% 
  dplyr::mutate(relative_abundance = paste(rel_abund,"\U00B1",se))


# III. ANOVA FOR RELATIVE ABUNDANCE ----

fit_aov_nmr <- function(dat) {
  a <-aov(relabund ~ treatment, data = dat)
  tibble(`p` = summary(a)[[1]][[1,"Pr(>F)"]])
} 


nmr_aov = 
  rel_abund %>% 
  group_by(group) %>% 
  do(fit_aov_nmr(.)) %>% 
  dplyr::mutate(p = round(p,4),
                asterisk = if_else(p<0.05,"*",as.character(NA))) %>% 
  dplyr::select(-p)

rel_abund_summary = 
  rel_abund_trt %>% 
  dplyr::select(group, treatment, relative_abundance) %>% 
  spread(treatment, relative_abundance) %>% 
  left_join(nmr_aov, by = c("group")) %>% 
  dplyr::mutate(
    Wetting = paste(Wetting, asterisk))



### OUTPUT ----
write.csv(rel_abund_trt, RELABUND_TRT, row.names = FALSE)
write.csv(rel_abund, RELABUND_CORES, row.names = FALSE)
write.csv(rel_abund_summary, RELABUND_SUMMARY, row.names = FALSE)
