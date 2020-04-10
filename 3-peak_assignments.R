
peak_assg = read.csv("data/nmr_peak_assignments.csv")
peaks = read.csv("processed/nmr_peaks.csv")


assg_points = 
  peak_assg %>% 
  filter(!point_range=="range")

peaks_match = 
  peaks %>% 
  left_join(assg_points, by = c("ppm" = "deltaH_ppm")) %>% 
  dplyr::mutate(matched = if_else(!is.na(moiety),"matched", "not matched"))

ggplot(peaks_match, aes(x = ppm, y = matched, color = abbrev))+
  geom_point()+
  facet_wrap(~Core)


peaks_match2 = 
  peaks %>% 
  left_join(assg_points, by = c("ppm" = "deltaH_ppm")) %>% 
  dplyr::mutate(matched = if_else(!is.na(moiety),"matched", "not matched"))
