function thresh = TFS_WiN_thresh(data, options, plotOption, option_data, conds, threshType, ttl)
% extracting/crowding data
data_group = zeros(size(data, 2), size(data, 3), size(data, 4));
for s = 1:size(data, 1)
    for i = 1:size(data, 2)
        data_cond = squeeze(data(s, i, :, :));
        if s == 1
            data_group(i, :, 1) = data_cond(:, 1);
        end
        data_group(i, :, 2:3) = squeeze(data_group(i, :, 2:3)) + data_cond(:, 2:3);
    end
end
% threshold calculation
% initialization
thresh = zeros(1, size(data_group, 1)); % number of conditions
h = zeros(1, size(data_group, 1));
idx_cond = 1:size(data_group, 1);
% group average thresholds
for i = idx_cond
    data_cond = squeeze(data_group(i, :, :));
    result = psignifit(data_cond,options);
    dataColor = [rand, rand, rand]; lineColor = dataColor;
    if plotOption
        figure();
    end
    [h(i), thresh(1, i)] = TFS_plotFit(result, dataColor, lineColor, plotOption, option_data, threshType, 'SNR [dB]');
end
if plotOption
    legend(h, conds(idx_cond, :), 'location', 'best');
    title(ttl);
end
end