function rt_mean = TFS_RT_mean(data)
data_group = zeros(size(data, 2), size(data, 3), size(data, 1)*size(data, 4));
for i = 1:size(data, 2)
    for j = 1:size(data, 3)
        for s = 1:size(data, 1)
            data_group(i, j, (s-1)*size(data, 4)+1:s*size(data, 4)) = squeeze(data(s, i, j, :));
        end
    end
end
% mean and std
upperlimit = 10e3; % 10 seconds
num_std = 2;
rt_mean = zeros(size(data, 2), size(data, 3));
% figure();
for  i = 1:size(data, 2)
    for j = 1:size(data, 3)
%         plot(squeeze(data_group(i, j, :)), 'o');
%         hold on;
        temp = squeeze(data_group(i, j, :));
        temp = temp(temp<upperlimit);
        rt_mean_temp = mean(temp);
        rt_std_temp = std(temp);
        temp = temp(temp<rt_mean_temp+num_std*rt_std_temp);
        temp = temp(rt_mean_temp-num_std*rt_std_temp<temp);
        rt_mean(i, j) = mean(temp);
    end
%     plot(rt_mean(i, :), '-o');
%     hold on;
end
end