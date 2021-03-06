function significance = TFS_plotRT_median(data_RT, idx_all)
%% grouping data based on either TFS or ILD sensitivity, depending on the index
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
% group medians: medians across individual subjects 
median1_orig = group_median(data_group1);
median2_orig = group_median(data_group2);
% difference between two groups
median_diff_orig = abs(median1_orig-median2_orig);
%% grouping data randomly into two groups without the index, but with the same number of subjects as in the two groups 
% based on the input—idx_all
num_drawing = 100e3; % number of random drawing
counter = 0; % number of drawings with group difference that exceeds the group difference above
for i = 1:num_drawing
    [data_group1_rand, data_group2_rand] = random_drawing(data_RT, idx_all);
    median1_rand = group_median(data_group1_rand);
    median2_rand = group_median(data_group2_rand);
    median_diff_rand = abs(median1_rand-median2_rand);
    if median_diff_rand > median_diff_orig
        counter = counter + 1;
    end
end
significance = counter/num_drawing;
end

function [data_group1, data_group2] = random_drawing(data_RT, idx_all)
% initialization of data arrays for two groups
numSubj1 = numel(idx_all(idx_all==1));
numSubj2 = numel(idx_all(idx_all==2));
numSubj_total = numel(idx_all);
data_group1 = zeros(numSubj1, size(data_RT, 2), size(data_RT, 3), size(data_RT, 4));
data_group2 = zeros(numSubj2, size(data_RT, 2), size(data_RT, 3), size(data_RT, 4));
% random drawing of subjects for two groups
index_group1 = randperm(numSubj_total, numSubj1);
index_group2 = setdiff(1:numSubj_total, index_group1);

% assigning/squeezing data
% group1
for i = 1:numSubj1
    data_group1(i, :, :, :) = squeeze(data_RT(index_group1(i), :, :, :));
end

for i = 1:numSubj2
    data_group2(i, :, :, :) = squeeze(data_RT(index_group2(i), :, :, :));
end

end
% obtaining group median across subjects
function median_group = group_median(data_group)
% calculate individual subject's median across all trials across all
% conditions
medians = zeros(1, size(data_group, 1));
for i = 1:size(data_group, 1)
    data_subj = squeeze(data_group(i, :, :, :));
    medians(i) = TFS_RT_median(data_subj);
end  
median_group = median(medians);
end