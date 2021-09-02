clear;
path = '/Users/Agudemu/Dropbox/Lab_SNAP/Experiment/online_experiments/snaplabonline/analysis/';
load(strcat(path, 'data_WiN.mat'));
data_rt = double(data_rt);
load(strcat(path, 'psignifit/', 'TFS.mat'));

% Grouped based on TFS sensitivity
TFS_plotRT(data_rt, conds, idx_all_itd_fm, C_itd_fm, 0, 0);