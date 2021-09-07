function TFS_plotRT(data_RT, conds, idx_all, Centroid, ILD, collapse)
if Centroid(1, 1) < Centroid(2, 1)
    % greater, less are used for calculating the significance values, which
    % one of them is used depends on the application
    greater = 1;
    less = 0;
    if ILD
        title1 = 'Good ILD'; %#ok<*NASGU>
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
numSubj1 = size(data_group1, 1);
numSubj2 = size(data_group2, 1);
% mean reaction time: average across 4 reps at each snr in each condition;
% i.e., the 4th dimention in data_RT is removed
mean_data_group1 = zeros(numSubj1, size(data_group1, 2), size(data_group1, 3));
mean_data_group2 = zeros(numSubj2, size(data_group2, 2), size(data_group2, 3));
subjs1 = 1:numSubj1;
subjs2 = 1:numSubj2;
for s = 1:numSubj1
    % merges the data from numSubj-1 individuals into one using jack-knife
    % sampling; discards any reaction time data points greater than 10 s;
    % then computes the mean and std and discards data points that are
    % beyond 2 std region; finally computes the mean of the remaining data
    % points
    mean_data_group1(s, :, :) = TFS_RT_mean(data_group1(subjs1(subjs1~=s), :, :, :));
end
for s = 1:numSubj2
    mean_data_group2(s, :, :) = TFS_RT_mean(data_group2(subjs2(subjs2~=s), :, :, :));
end
% mean across srns for in each condition
mean_across_snr1 = mean(mean_data_group1, 3);
mean_across_snr2 = mean(mean_data_group2, 3);
%% group mean and std
mean1 = mean(mean_across_snr1);
mean2 = mean(mean_across_snr2);
var1 = var(mean_across_snr1)*(numSubj1-1); % check if this would be affected by the averaging across snrs
var2 = var(mean_across_snr2)*(numSubj2-1);
if collapse == 0 % plot data for different conditions separately
    error1 = sqrt(var1);
    error2 = sqrt(var2);
else % merge data across conditions, reverse variane pooling
    var1_mean = 1/(sum(1./var1));% if conditions are independent
    var2_mean = 1/(sum(1./var2));
    error1 = [sqrt(var1_mean), 0];
    error2 = [sqrt(var2_mean), 0];
    mean1 = [sum(mean1./var1)/sum(1./var1), 0];
    mean2 = [sum(mean2./var2)/sum(1./var2), 0];
end
% put mean and error into matrix
mean_group = [mean1', mean2'];
error_group = [error1', error2'];
% two-sample t-test between two groups
nconds = size(mean1, 2);
p = zeros(nconds, 1);
Z = zeros(nconds, 1);
for i = 1:nconds
    % remove n1, n2, one-tail
    Z(i) = (mean1(i) - mean2(i)-0)/sqrt(error1(i)^2+error2(i)^2);
    %Z = (mean1-mean2-0)/sqrt(std2^2/n1+std2^2/n2);
    if less
        p(i) = (1-normcdf(Z(i)));
    else
        p(i) = 1-(1-normcdf(Z(i)));
    end
end

Y = mean_group;
E = error_group;
C = [1 0 0;
    0 0 1];
% significance
P = nan(numel(Y), numel(Y));
for i = 1:nconds
    if p(i) <= 0.05
        P(i, i+nconds) = p(i); % data from the same group (poor vs good) are listed vertically;
        % so, each row represents one condition with poor and good
        % subgroups; the pairwise comparision between two subgroups within
        % a condition is P(i, i+nconds)
    end
end
% Make P symmetric, by copying the upper triangle onto the lower triangle
PT = P';
lidx = tril(true(size(P)), -1);
P(lidx) = PT(lidx);
% plot bars
ax = gca;
ax_bar = superbar(Y, 'E', E, 'P', P, 'BarFaceColor', 'none', 'BarEdgeColor', permute(C, [3 1 2]), 'ErrorbarLineWidth', 3, 'PLineWidth', 3, 'PStarFontSize', 24);
legend(ax_bar(1,:), group_legend, 'Location', 'NorthWest', 'FontSize',14);
ylim([2500, 3800]);
if collapse
    xlim([0.5, 1.5]);
    xticks(1);
    xticklabels('all conds');
else
    xlim([0.5 12.5]);
    xticks(1:12);
    xticklabels(conds);
end
xtickangle(-45);
ylabel('Response time [ms]');
grid on;
set(ax, 'FontSize', 32);
end