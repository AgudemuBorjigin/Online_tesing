function rt_median = TFS_RT_median(data)
% crowding reaction times from all repetitions into one entity
data_all = zeros(1, size(data, 1)*size(data, 2)*size(data, 3));
for i = 1:size(data, 1)
    for j = 1:size(data, 2)
        data_all((i-1)*size(data, 2)*size(data, 3)+(j-1)*size(data, 3)+1:(i-1)*size(data, 2)*size(data, 3)+j*size(data, 3))...
            = data(i, j, :);
    end
end
% median
rt_median = median(data_all);
end