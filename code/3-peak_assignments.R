
peak_assg = read.csv("data/nmr_peak_assignments.csv")
peaks = read.csv("processed/nmr_peaks.csv")


assg_points = 
  peak_assg %>% 
  filter(!point_range=="range")

peaks_match = 
  peaks %>% 
  dplyr::select(Core, ppm) %>% 
  left_join(assg_points, by = c("ppm" = "deltaH_ppm")) %>% 
  #dplyr::mutate(matched = if_else(!is.na(moiety),"matched", "not matched"))
  filter(!is.na(moiety)) %>% 
  dplyr::mutate(matched = if_else(!is.na(moiety),"matched", "not matched"))


ggplot(peaks_match, aes(x = ppm, y = matched, color = abbrev))+
  geom_point()+
  geom_point(data = peaks_match2, aes(x = ppm, y = matched, color = abbrev), shape = 2 )+
  facet_wrap(~Core)


peaks_match2 = 
  subset(merge(dplyr::select(peaks,Core,ppm), peak_assg), deltaH_start <= ppm & ppm <= deltaH_stop) %>% 
  dplyr::select(-deltaH_ppm) %>% 
  dplyr::mutate(matched = if_else(!is.na(moiety),"matched", "not matched"))

matched = rbind(peaks_match, peaks_match2)

matched2 = 
  peaks %>% 
  left_join(matched, by = c("Core","ppm"))

ggplot(matched2, aes(x = ppm, y = matched, color = abbrev))+
  geom_point()+
  scale_x_reverse()+
  facet_wrap(~Core)
