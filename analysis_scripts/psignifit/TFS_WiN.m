clear;
path = '/Users/Agudemu/Dropbox/Lab_SNAP/Experiment/online_experiments/snaplabonline/Online_tesing/analysis_scripts/';
load(strcat(path, 'data_WiN.mat'));
data = double(data);
data_WiN = data;
load(strcat(path, 'psignifit/', 'TFS.mat'));
% Population data, without grouping
% TFS_plotWiN(data_WiN, conds, idx_all_itd_fm, C_itd_fm, 0, 1)

% Grouped based on TFS sensitivity
% TFS_plotWiN(data_WiN, conds, idx_all_itd_fm, C_itd_fm, 0, 0);

% Grouped based on ILD
TFS_plotWiN(data_WiN, conds, idx_all_ild, C_ild, 1, 0);
