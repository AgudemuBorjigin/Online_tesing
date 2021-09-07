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
   1) "TFS.m": run this script first to group all listeners into two groups, based on their sensory measurements
      1) "TFS_plotFit.m": estimates the threshold, based on Bayetian method; plot optional
      2) Regresses out the ILD from ITD and binaural FM and the combination of ITD and FM from the ILD
      3) "TFS_grouping.m": groups individuals based on those residuals
         1) "TFS_clustering.m": group subjects based on k-means clustering, based on ITD and FM thresholds
            or ILD thresholds only
         2) "TFS_plotGroup.m": plotting Bayesian estimates for population data that are grouped based on ITD, FM, and ILD
            1) "TFS_subgrouping.m": groups the data
            2) "TFS_std.m": jsck-knife sampling for calculating the std; each subject does not have enough trials;
               1) "TFS_sum.m":
   2) "TFS_WiN.m": plot word-in-noise data, grouped based on TFS measures
      1) "TFS_plotWiN.m"—main function
      2) "TFS_WiN_thresh.m"
      3) "superbar.m": bar plots with significance star
         1) "TFS_groupbar.m":
   3) "TFS_reaction_time.m": 
      1) "TFS_plotRT.m":
         1) "TFS_RT_mean.m": crowds reaction times from all but one individuals (jack-knife resampling) into one entity
         2) "superbar.m": bar plots with significance star. Examples of the usage of this function is in the 
         "scottclowe-superbar-ce333a9" folder ("demo_superbar.m")