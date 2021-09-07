function TFS_grouping(thresh_ITD, thresh_FM, thresh_ILD, data_ITD, data_FM, data_ILD, options, threshType)
%% removing "bad" subject data
filter = 0;
if filter
    j = 0; %#ok<UNRCH>
    for i = 1:numel(thresh_ITD)
        if thresh_ITD(i) < 100 && thresh_FM(i) < 3 && thresh_ILD(i) < 3
            j = j + 1;
            idx_good(j) = i;
        end
    end
else
    idx_good = 1:numel(thresh_ITD);
end
%% k-means clustering
color = ['r', 'b'];
data_pairs = [thresh_ITD, thresh_FM];
[idx_all_itd_fm, C_itd_fm] = TFS_clustering(data_pairs, idx_good, color);
data_pairs = thresh_ILD;
[idx_all_ild, C_ild] = TFS_clustering(data_pairs, idx_good, color);
%% plotting group data
xlabel = 'ITD [us]'; % 'fdev [dB re: 1 Hz]', 'ILD [dB]'
% ITD data grouped by TFS sensitivity
TFS_plotGroup(data_ITD, idx_all_itd_fm, options, threshType, color, xlabel)
% ITD data grouped by non-TFS sensitivity
TFS_plotGroup(data_ITD, idx_all_ild, options, threshType, color, xlabel)
xlabel = 'fdev [dB re: 1 Hz]';
% FM data grouped by TFS sensitivity
TFS_plotGroup(data_FM, idx_all_itd_fm, options, threshType, color, xlabel)
% FM data grouped by non-TFS sensitivity
TFS_plotGroup(data_FM, idx_all_ild, options, threshType, color, xlabel)
%% save
savename = '/Users/Agudemu/Dropbox/Lab_SNAP/Experiment/online_experiments/snaplabonline/Online_tesing/analysis_scripts/psignifit/TFS.mat';
save(savename, 'idx_all_itd_fm', 'C_itd_fm', 'idx_all_ild', 'C_ild');

end