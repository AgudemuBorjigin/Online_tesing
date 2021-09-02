function TFS_plotRT(data_RT, conds, idx_all, C, ILD, all)
%% grouping data
data_group1 = zeros(numel(idx_all(idx_all==1)), size(data_RT, 2), size(data_RT, 3), size(data_RT, 4));
data_group2 = zeros(numel(idx_all(idx_all==2)), size(data_RT, 2), size(data_RT, 3), size(data_RT, 4));
% squeezing data
cnt1 = 0;
cnt2 = 0;
for s = 1:size(data_RT, 1)
    if idx_all(s) == 1
        cnt1 = cnt1 + 1;
        data_group1(cnt1, :, :, :) = squeeze(data_RT(s, :, :, :));
    else
        cnt2 = cnt2 + 1;
        data_group2(cnt2, :, :, :) = squeeze(data_RT(s, :, :, :));
    end
end
%% jack-knife sampling
numSubjs1 = size(data_group1, 1);
numSubjs2 = size(data_group2, 1);
mean_data_group1 = zeros(numSubjs1, size(data_group1, 2), size(data_group1, 3));
mean_data_group2 = zeros(numSubjs2, size(data_group2, 2), size(data_group2, 3));
subjs1 = 1:numSubjs1;
subjs2 = 1:numSubjs2;
for s = 1:numSubjs1
    mean_data_group1(s, :, :) = TFS_RT_mean(data_group1(subjs1(subjs1~=s), :, :, :));
end
for s = 1:numSubjs2
    mean_data_group2(s, :, :) = TFS_RT_mean(data_group2(subjs2(subjs2~=s), :, :, :));
end
%%
% %% assigning appropriate labels for each group
% group_legend = cell(1,2);
% nconds = size(conds, 1);
% conds_legend = {'intonation', 'reverb, intonation'...
%     'steady noise', 'reverb, steady noise',...
%     'reverb, pitch', 'reverb, space', 'reverb, pitch+space', 'reverb, control',...
%     'pitch', 'space', 'pitch+space', 'control'};
% if C(1, 1) < C(2, 1)
%     greater = 1;
%     less = 0;
%     if ILD
%         title1 = 'Good ILD';
%         title2 = 'Poor ILD';
%         group_legend{1} = 'Good ILD';
%         group_legend{2} = 'Poor ILD';
%     else
%         title1 = 'Good TFS';
%         title2 = 'Poor TFS';
%         group_legend{1} = 'Good TFS';
%         group_legend{2} = 'Poor TFS';
%     end
% else
%     greater = 0;
%     less = 1;
%     if ILD
%         title1 = 'Poor ILD';
%         title2 = 'Good ILD';
%         group_legend{1} = 'Poor ILD';
%         group_legend{2} = 'Good ILD';
%     else
%         title1 = 'Poor TFS';
%         title2 = 'Good TFS';
%         group_legend{1} = 'Poor TFS';
%         group_legend{2} = 'Good TFS';
%     end
% end
% 
% %% plot
% figure();
% ax4 = gca;
% ax_diff = TFS_groupbar(diff1, diff2, group_legend, size(diff1, 1), size(diff2, 1), less, 1, 0);
% set(ax_diff, 'LineWidth', 3);
% ylabel(ax4, 'reverb vs non-reverb thresholds [dB]');
% title(ax4, 'Threshold increase [dB]');
% legend(ax_diff(1,:), group_legend, 'Location', 'NorthWest', 'FontSize',14);
% xlim(ax4, [0.5 1.5]);
% xticks(ax4, 1);
% xticklabels(ax4, 'all conds');
% xtickangle(ax4, -45);
% grid(ax4, 'on');
% set(ax4, 'FontSize', 32);
end