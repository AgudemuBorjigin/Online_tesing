function [data_group1, data_group2, data_group, data1, data2] = TFS_subgrouping(data, idx_all)
% group data into two groups based on idx_all
data_group1 = zeros(size(data, 2), size(data, 3));
data_group2 = data_group1;
data_group = data_group1; % grand average
data1 = zeros(sum(idx_all(:)==1), size(data, 2), size(data, 3));
data2 = zeros(sum(idx_all(:)==2), size(data, 2), size(data, 3));
count_1 = 0;
count_2 = 0;
for s = 1:size(data, 1)
    data_temp = squeeze(data(s, :, :));
    if s == 1
        data_group1(:, 1) = data_temp(:, 1);
        data_group2(:, 1) = data_temp(:, 1);
        data_group(:, 1) = data_temp(:, 1);
    end
    if idx_all(s) == 1
        count_1 = count_1 + 1;
        data_group1(:, 2:3) = squeeze(data_group1(:, 2:3)) + data_temp(:, 2:3);
        data1(count_1, :, :) = data_temp;
    else
        count_2 = count_2 + 1;
        data_group2(:, 2:3) = squeeze(data_group2(:, 2:3)) + data_temp(:, 2:3);
        data2(count_2, :, :) = data_temp;
    end
    data_group(:, 2:3) = squeeze(data_group(:, 2:3)) + data_temp(:, 2:3);
end
end