function data_group = TFS_sum(data)
% sums data across the first dimension
data_group = zeros(size(data, 2), size(data, 3));
for s = 1:size(data, 1)
    for i = 1:size(data, 2)
        data_cond = squeeze(data(s, i, :));
        if s == 1
            data_group(i, 1) = data_cond(1);
        end
        data_group(i, 2:3) = data_group(i, 2:3) + data_cond(2:3)';
    end
end
end