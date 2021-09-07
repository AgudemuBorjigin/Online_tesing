function TFS_plotWiN(data_WiN, conds, idx_all, C, ILD, all)
threshType = 'WiN';
% parameter settings for Bayesian functions
options = struct;
options.sigmoidName = 'norm'; % choose a cumulative Gaussian as the sigmoid
options.expType     = 'nAFC'; % choose n-AFC as the paradigm of the experiment
options.expN = 6;
options.threshPC = 0.5; % it was not set for the TFS measures
% plot options
plotOption = 0;
option_data = 0;
group_legend = cell(1,2);
nconds = size(conds, 1);
%% grouping data
% if all == 1, plot data without grouping
if all == 0
    data_group1 = zeros(numel(idx_all(idx_all==1)), size(data_WiN, 2), size(data_WiN, 3), size(data_WiN, 4));
    data_group2 = zeros(numel(idx_all(idx_all==2)), size(data_WiN, 2), size(data_WiN, 3), size(data_WiN, 4));
    cnt1 = 0;
    cnt2 = 0;
    % grouping the data into their respective group
    for s = 1:size(data_WiN, 1)
        if idx_all(s) == 1
            cnt1 = cnt1 + 1;
            data_group1(cnt1, :, :, :) = squeeze(data_WiN(s, :, :, :));
        else
            cnt2 = cnt2 + 1;
            data_group2(cnt2, :, :, :) = squeeze(data_WiN(s, :, :, :));
        end
    end
    % labeling the group as good or poor based on their respective centroid
    % values
    if C(1, 1) < C(2, 1)
        greater = 1;
        less = 0;
        if ILD
            title1 = 'Good ILD';
            title2 = 'Poor ILD';
            group_legend{1} = 'Good ILD';
            group_legend{2} = 'Poor ILD';
        else
            title1 = 'Good TFS';
            title2 = 'Poor TFS';
            group_legend{1} = 'Good TFS';
            group_legend{2} = 'Poor TFS';
        end
    else
        greater = 0;
        less = 1;
        if ILD
            title1 = 'Poor ILD';
            title2 = 'Good ILD';
            group_legend{1} = 'Poor ILD';
            group_legend{2} = 'Good ILD';
        else
            title1 = 'Poor TFS';
            title2 = 'Good TFS';
            group_legend{1} = 'Poor TFS';
            group_legend{2} = 'Good TFS';
        end
    end
end
%% calculating thresholds
if all % without grouping
    numSubj = numel(idx_all);
    thresh = zeros(numSubj, nconds);
    subjs = 1:numSubj;
    % jackknife resampling
    for i = 1:numSubj
        thresh(i, :) = TFS_WiN_thresh(data_WiN(subjs(subjs~=i), :, :, :), options, plotOption, option_data, conds, threshType, '');
    end
    % reordering the thresholds by conditions
    thresh = [thresh(:, 12), thresh(:, 9:11), thresh(:, 1), ...
        thresh(:, 3), thresh(:, 8), thresh(:, 5:7), thresh(:, 2), ...
        thresh(:, 4)];
    mr_a = thresh(:, 1) - thresh(:, [1,2,3,4,6]); % masking release (anechoic)
    mr_r = thresh(:, 7) - thresh(:, [7,8,9,10,12]); % masking release (reverberent)
    mr = thresh(:, 1) - thresh(:, :); % masking release (all conditions with reference to anechoic-no-cue condition)
    savename = '/Users/Agudemu/Dropbox/Lab_SNAP/Experiment/online_experiments/snaplabonline/Online_tesing/analysis_scripts/psignifit/TFS_thresh_all.mat';
    save(savename, 'thresh');
else % with grouping
    numSubj1 = size(data_group1, 1);
    numSubj2 = size(data_group2, 1);
    thresh1 = zeros(numSubj1, nconds);
    thresh2 = zeros(numSubj2, nconds);
    subjs1 = 1:numSubj1;
    subjs2 = 1:numSubj2;
    % jackknife resampling for two groups
    for i = 1:numSubj1
        thresh1(i, :) = TFS_WiN_thresh(data_group1(subjs1(subjs1~=i), :, :, :), options, plotOption, option_data, conds, threshType, title1);
    end
    for i = 1:numSubj2
        thresh2(i, :) = TFS_WiN_thresh(data_group2(subjs2(subjs2~=i), :, :, :), options, plotOption, option_data, conds, threshType, title2);
    end
    % changing the order by conditions
    thresh1 = [thresh1(:, 12), thresh1(:, 9:11), thresh1(:, 1), ...
        thresh1(:, 3), thresh1(:, 8), thresh1(:, 5:7), thresh1(:, 2), ...
        thresh1(:, 4)];
    thresh2 = [thresh2(:, 12), thresh2(:, 9:11), thresh2(:, 1), ...
        thresh2(:, 3), thresh2(:, 8), thresh2(:, 5:7), thresh2(:, 2), ...
        thresh2(:, 4)];
    % masking release in anechoic, reverberent
    mr1_a = thresh1(:, 1) - thresh1(:, [1,2,3,4,6]);
    mr2_a = thresh2(:, 1) - thresh2(:, [1,2,3,4,6]);
    mr1_r = thresh1(:, 7) - thresh1(:, [7,8,9,10,12]);
    mr2_r = thresh2(:, 7) - thresh2(:, [7,8,9,10,12]);
    % mr1 = thresh1(:, 1) - thresh1(:, :);
    % mr2 = thresh2(:, 1) - thresh2(:, :);
    diff1 = thresh1(:, [7,8,9,10,12]) - thresh1(:, [1,2,3,4,6]);
    diff2 = thresh2(:, [7,8,9,10,12]) - thresh2(:, [1,2,3,4,6]);
    if ILD
        savename = '/Users/Agudemu/Dropbox/Lab_SNAP/Experiment/online_experiments/snaplabonline/Online_tesing/analysis_scripts/psignifit/TFS_thresh_groups_ILD.mat';
    else
        savename = '/Users/Agudemu/Dropbox/Lab_SNAP/Experiment/online_experiments/snaplabonline/Online_tesing/analysis_scripts/psignifit/TFS_thresh_groups.mat';
    end
    save(savename, 'thresh1', 'thresh2');
end
%% plotting the data with error bar
% masking release
conds_legend = {'intonation', 'reverb, intonation'...
    'steady noise', 'reverb, steady noise',...
    'reverb, pitch', 'reverb, space', 'reverb, pitch+space', 'reverb, control',...
    'pitch', 'space', 'pitch+space', 'control'};
% changing the order
conds_legend = [conds_legend(12), conds_legend(9:11), conds_legend(1), conds_legend(3), ...
    conds_legend(8), conds_legend(5:7), conds_legend(2), conds_legend(4)];
conds_legend_a = conds_legend([1,2,3,4,6]);
% plotting
if all % without grouping
    mean_a = mean(mr_a); % average across subjects
    error_a = sqrt(var(mr_a)*(numSubj-1));
    mean_r = mean(mr_r);
    error_r = sqrt(var(mr_r)*(numSubj-1));
    mean_all = mean(mr);
    error_all = sqrt(var(mr)*(numSubj-1));
    C = [1 0 0]; 
    
    figure();
    ax1 = gca;
    ax_a = superbar(mean_a, 'E', error_a, 'BarFaceColor', 'none', 'BarEdgeColor', permute(C, [3 1 2]), 'ErrorbarLineWidth', 1.5);
    set(ax_a, 'LineWidth', 3);
    
    figure();
    ax2 = gca;
    ax_r = superbar(mean_r, 'E', error_r, 'BarFaceColor', 'none', 'BarEdgeColor', permute(C, [3 1 2]), 'ErrorbarLineWidth', 1.5);
    set(ax_r, 'LineWidth', 3);
    
    figure();
    ax4 = gca;
    ax_r_dashed = superbar(mean_r, 'E', error_r, 'BarFaceColor', 'none', 'BarEdgeColor', permute(C, [3 1 2]), 'ErrorbarLineWidth', 1.5);
    set(ax_r_dashed, 'LineWidth', 3);
    set(ax_r_dashed, 'LineStyle', '--');
    hold on;
    ax_a_r = superbar(mean_a, 'E', error_a, 'BarFaceColor', 'none', 'BarEdgeColor', permute(C, [3 1 2]), 'ErrorbarLineWidth', 1.5);
    set(ax_a_r, 'LineWidth', 3);
    ylabel(ax4, 'Thresholds [dB] re: control/reverb,control');
    title(ax4, strcat('Masking release - SNR difference [dB], n =', num2str(numel(idx_all))));
    
    figure();
    ax3 = gca;
    ax = superbar(mean_all, 'E', error_all, 'BarFaceColor', 'none', 'BarEdgeColor', permute(C, [3 1 2]), 'ErrorbarLineWidth', 1.5);
    set(ax, 'LineWidth', 3);
else % with grouping
    figure();
    ax1 = gca;
    ax_a = TFS_groupbar(mr1_a, mr2_a, size(mr1_a, 1), size(mr2_a, 1), greater, 0, 0);
    set(ax_a, 'LineWidth', 3);
    legend(ax_a(1,:), group_legend, 'Location', 'Best');
    
    figure();
    ax2 = gca;
    ax_r = TFS_groupbar(mr1_r, mr2_r, size(mr1_r, 1), size(mr2_r, 1), greater, 0, 0);
    set(ax_r, 'LineWidth', 3);
    legend(ax_r(1,:), group_legend, 'Location', 'Best');
    
    figure();
    ax3 = gca;
    ax_r_dashed = TFS_groupbar(mr1_r, mr2_r, size(mr1_r, 1), size(mr2_r, 1), greater, 0, 1);
    set(ax_r_dashed, 'LineWidth', 3);
    set(ax_r_dashed, 'LineStyle', '--');
    hold on;
    ax_a_r = TFS_groupbar(mr1_a, mr2_a, size(mr1_a, 1), size(mr2_a, 1), greater, 0, 0);
    set(ax_a_r, 'LineWidth', 3);
    ylabel(ax3, 'Thresholds [dB] re: control/reverb,control');
    title(ax3, strcat('Masking release - SNR difference [dB], n =', num2str(numel(idx_all))));
    legend(ax_a_r(1,:), group_legend, 'Location', 'Best');
    
    figure();
    ax4 = gca;
    ax_diff = TFS_groupbar(diff1, diff2, size(diff1, 1), size(diff2, 1), less, 1, 0);
    set(ax_diff, 'LineWidth', 3);
    ylabel(ax4, 'reverb vs non-reverb thresholds [dB]');
    title(ax4, 'Threshold increase [dB]');
    legend(ax_diff(1,:), group_legend, 'Location', 'NorthWest', 'FontSize',14);
end
xlim(ax1, [0.5 5.5]);
xlim(ax2, [0.5 5.5]);
xlim(ax3, [0.5 5.5]);
xticks(ax1, 1:5);
xticks(ax2, 1:5);
xticks(ax3, 1:11);
xticklabels(ax1, conds_legend_a);
xticklabels(ax2, conds_legend_a);
xticklabels(ax3, conds_legend_a);
xtickangle(ax1, -45);
xtickangle(ax2, -45);
xtickangle(ax3, -45);
ylabel(ax1, 'Thresholds [dB] re: control');
ylabel(ax2, 'Thresholds [dB] re: reverb, control');
ylabel(ax3, 'Thresholds [dB] re: control');
title(ax1, strcat('Masking release - SNR difference [dB], n =', num2str(numel(idx_all))));
title(ax2, strcat('Masking release, reverberaton - SNR difference [dB], n =', num2str(numel(idx_all))));
title(ax3, strcat('Masking release - SNR difference [dB], n =', num2str(numel(idx_all))));
grid(ax1, 'on');
grid(ax2, 'on');
grid(ax3, 'on');
set(ax1, 'FontSize', 32);
set(ax2, 'FontSize', 32);
set(ax3, 'FontSize', 32);
xlim(ax4, [0.5 1.5]);
xticks(ax4, 1);
xticklabels(ax4, 'all conds');
xtickangle(ax4, -45);
grid(ax4, 'on');
set(ax4, 'FontSize', 32);
end