# Online_tesing
Scripts for analyzing data that are collected from online platformâ€”Prolific

1. In the "analysis_scripts" folder:
   1) analysis_WiN.py: extracts the data from .json file. The data is stored and downloadable in .json
      format from Prolific. The data is from "word in noise" listening tasks. The extracted data is stored in .mat format for MATLAB 
      analysis. Run this first before other scripts. 
   2) analysis_FM.py: data extraction for binaural FM listening tasks.
   3) analysis_ITD.py: data extraction for ITD detection task.
   4) analysis_ILD.py: data extraction for ILD detection task. 

2. A subfolder of "analysis_scripts"—psignifit:
   1) this folder includes all MATLAB scripts for analyzing the data; relevant file names all start with "TFS"; 
   2) the files without "TFS" in their filenames are related to generating Bayesian estimate of psychometric functions
   3) "scottclowe-superbar-ce333a9" subfolder includes functions for plotting errorbars, with "significe" stars
   
3. The "TFS" analysis scripts within the "psignifit" subfolder:
   1) 