

spectra3 = 
  subset(merge(spectra2, bins2), start <= ppm & ppm <= stop) %>% 
  dplyr::select(source,ppm, intensity, group) %>% 
  group_by(source, group) %>% 
  dplyr::summarize(intensity = sum(intensity)) %>% 
  group_by(source) %>% 
  dplyr::mutate(total = sum(intensity),
                relabund = round((intensity/total)*100,2))%>% 
  mutate(pos = cumsum(relabund)- relabund/2)

ggplot(data=spectra3, aes(x="", y=relabund, fill=group)) +
  geom_bar(stat="identity", alpha=0.7) +
  #geom_text(aes(x= "", y=pos, label = relabund), size=4) +  # note y = pos
  facet_grid(facets = .~source, labeller = label_value) +
  coord_polar(theta = "y")+theme_bw()


