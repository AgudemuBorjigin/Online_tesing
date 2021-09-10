clear;
path = '/Users/Agudemu/Dropbox/Lab_SNAP/Experiment/online_experiments/snaplabonline/Online_tesing/analysis_scripts/';
load(strcat(path, 'data_WiN.mat'));
data_rt = double(data_rt);
load(strcat(path, 'psignifit/', 'TFS.mat'));

%% mean and std 
% Grouped based on TFS sensitivity
% TFS_plotRT(data_rt, conds, idx_all_itd_fm, C_itd_fm, 0, 1);
% Grouped based on ILD sensitivity
% TFS_plotRT(data_rt, conds, idx_all_ild, C_ild, 1, 1);

%% median 
% TFS_plotRT_median(data_rt, idx_all_itd_fm)

TFS_plotRT_median(data_rt, idx_all_ild)
