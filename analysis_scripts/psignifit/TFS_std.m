function [percent_std, percent_std_jk, thresh_std, thresh_std_jk, thresh_jk] = TFS_std(data, numSubj, options, dataColor, lineColor, threshType)
thresh = zeros(1, numSubj);
for i = 1:numSubj
    result = psignifit(squeeze(data(i, :, :)),options);
    [~, thresh(i)] = TFS_plotFit(result, dataColor, lineColor, 0, 0, threshType);
end
thresh_std = std(thresh);

percent = zeros(size(data, 2), numSubj);
for i = 1:numSubj
    data_temp = squeeze(data(i, :, :));
    percent(:, i) = data_temp(:, 2)./data_temp(:, 3);
    if i == numSubj
        percent_std = std(percent, 0, 2);
    end
end
%% jack-knife sampling
percent_jk = zeros(size(data, 2), numSubj);
thresh_jk = zeros(1, numSubj);
subjs = 1:numSubj;
for i = 1:numSubj
    % percent correct
    data_group = TFS_sum(data(subjs(subjs~=i), :, :));
    percent_jk(:, i) = data_group(:, 2)./data_group(:, 3);
    % threshold
    result = psignifit(data_group,options);
    [~, thresh_jk(i)] = TFS_plotFit(result, dataColor, lineColor, 0, 0, threshType);
    if i == numSubj
        %percent_std_jk = std(percent_jk, 0, 2);
        var_percent = var(percent_jk, 0, 2)*(numSubj-1);
        percent_std_jk = sqrt(var_percent);
        var_thresh = var(thresh_jk)*(numSubj-1);
        thresh_std_jk = sqrt(var_thresh);
    end
end
end