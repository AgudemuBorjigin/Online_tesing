function TFS_plotGroup(data, idx_all, options, threshType, color, xlabel)
%% grouping data based on idx_all (from clustering)
[data_group1, data_group2, data_group, data1, data2] = TFS_subgrouping(data, idx_all);
%% group threshold
plotOrNot = 1;
plotData = 1;
%dataColor = [rand, rand, rand]; lineColor = dataColor;
dataColor = [0, 0, 0]; lineColor = dataColor;
dataColor1 = color(1); lineColor1 = dataColor1;
dataColor2 = color(2); lineColor2 = dataColor2;
plot_groupData(data_group1, data_group2, data_group,...
    data1, data2, data, ...
    options, plotOrNot, ...
    dataColor1, dataColor2, dataColor, ...
    lineColor1, lineColor2, lineColor, ...
    plotData, threshType, xlabel)
end

function plot_groupData(data_group1, data_group2, data_group,...
    data1, data2, data, ...
    options, plotOrNot, ...
    dataColor1, dataColor2, dataColor, ...
    lineColor1, lineColor2, lineColor, ...
    plotData, threshType, xlabel)
thresh_groups = zeros(2, 1);
result1 = psignifit(data_group1,options);
result2 = psignifit(data_group2,options);
result = psignifit(data_group,options);

if plotOrNot
    figure();
end
[~, percent_std_jk1, ~, thresh_std_jk1, ~] = TFS_std(data1, size(data1, 1), options, dataColor, lineColor, threshType);
[~, thresh_groups(1, 1)] = TFS_plotFit(result1, dataColor1, lineColor1, plotOrNot, plotData, threshType, xlabel, 1.96*percent_std_jk1, 1.96*thresh_std_jk1);
[~, percent_std_jk2, ~, thresh_std_jk2, ~] = TFS_std(data2, size(data2, 1), options, dataColor, lineColor, threshType);
[~, thresh_groups(2, 1)] = TFS_plotFit(result2, dataColor2, lineColor2, plotOrNot, plotData, threshType, xlabel, 1.96*percent_std_jk2, 1.96*thresh_std_jk2); %#ok<NASGU>

if plotOrNot
    figure(); 
end
[~, percent_std_jk, ~, thresh_std_jk, ~] = TFS_std(data, size(data, 1), options, dataColor, lineColor, threshType);
% 1.96*std-95% confidence interval
[~, ~] = TFS_plotFit(result, dataColor, lineColor, plotOrNot, plotData, threshType, xlabel, 1.96*percent_std_jk, 1.96*thresh_std_jk);
end