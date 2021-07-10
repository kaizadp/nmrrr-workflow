## Processing NMR spectra in MestreNova

perform these steps before running the R scripts for further processing and analysis.  

1. phase correction
- perform automatic phase correction
- perform manual correction to fine-tune phasing
2. baseline correction
- perform manual baseline correction
  - ablative method preferred for environmental/soil samples
3. line fitting and peak picking
- create new fitting region (typically 0-10 ppm)
- perform automatic peak picking
  - use GSD (global spectral deconvolution)
  - reference by solvent
- remove water peak (optional)
- save to new spectrum (peaks only) 
- normalize to largest peak
4. exporting
- to plot spectra, save the FID file as .csv
- to calculate relative abundances, save only the peaks table as .csv
