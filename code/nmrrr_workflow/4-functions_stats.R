# III. PERMANOVA functions ----------------------------------------------------------
library(vegan)

compute_nmr_permanova = function(relabund_cores){
  relabund_wide = 
    relabund_cores %>% 
    ungroup() %>% 
    pivot_wider(names_from = group, values_from = relabund)
  
  (permanova_tzero = 
    adonis(relabund_wide %>% 
             dplyr::select(where(is.numeric))  ~ 
             treatment,
           data = relabund_wide))
}


#
# IV. PCA functions -----------------------------------------------------------------
# devtools::install_github("miraKlein/ggbiplot")
library(ggbiplot)

fit_pca_function = function(dat){
  relabund_pca=
    dat %>% 
    ungroup %>% 
    dplyr::select(-1)
  
  num = 
    relabund_pca %>% 
    dplyr::select(c(aliphatic1, aliphatic2, aromatic, alphah, amide))
  
  grp = 
    relabund_pca %>% 
    dplyr::select(-c(aliphatic1, aliphatic2, aromatic, alphah, amide)) %>% 
    dplyr::mutate(row = row_number())
  
  pca_int = prcomp(num, scale. = T)
  
  list(num = num,
       grp = grp,
       pca_int = pca_int)
}
compute_fticr_pca = function(relabund_cores){
  
  relabund_wide = 
    relabund_cores %>% 
    ungroup() %>% 
    pivot_wider(names_from = group, values_from = relabund)
  
  ## PCA input files
  pca_data = fit_pca_function(relabund_wide)
  
  ## PCA plot
  (gg_pca = 
    ggbiplot(pca_data$pca_int, obs.scale = 1, var.scale = 1,
             groups = as.character(pca_data$grp$treatment), 
             ellipse = TRUE, circle = FALSE, var.axes = TRUE, alpha = 0) +
    geom_point(size=2,stroke=1, alpha = 0.5,
               aes(shape = groups,
                   color = groups))+
    theme_classic()+
    NULL)
}
