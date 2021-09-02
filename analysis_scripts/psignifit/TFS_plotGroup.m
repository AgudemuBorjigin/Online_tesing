function TFS_plotGroup(data_ITD, data_FM, data_ILD, idx_all, options, threshType, color)
%% grouping data
% ITD
[data_group1_ITD, data_group2_ITD, data_group_ITD, data1_ITD, data2_ITD] = TFS_subgrouping(data_ITD, idx_all);
% FM
[data_group1_FM, data_group2_FM, data_group_FM, data1_FM, data2_FM] = TFS_subgrouping(data_FM, idx_all);
% ILD
[data_group1_ILD, data_group2_ILD, data_group_ILD, data1_ILD, data2_ILD] = TFS_subgrouping(data_ILD, idx_all);
%% group threshold
plotOrNot = 1;
plotData = 1;
%dataColor = [rand, rand, rand]; lineColor = dataColor;
dataColor = [0, 0, 0]; lineColor = dataColor;
dataColor1 = color(1); lineColor1 = dataColor1;
dataColor2 = color(2); lineColor2 = dataColor2;

% % FM
% thresh_FM_groups = zeros(2, 1);
% result1_FM = psignifit(data_group1_FM,options);
% result2_FM = psignifit(data_group2_FM,options);
% result_FM = psignifit(data_group_FM,options);
% if plotOrNot
%     figure();
% end
% [~, thresh_FM_groups(1, 1)] = TFS_plotFit(result1_FM, dataColor1, lineColor1, plotOrNot, plotData, threshType, 'fdev [dB re: 1 Hz]');
% [~, thresh_FM_groups(2, 1)] = TFS_plotFit(result2_FM, dataColor2, lineColor2, plotOrNot, plotData, threshType, 'fdev [dB re: 1 Hz]'); %#ok<NASGU>
% if plotOrNot
%     figure(); 
% end
% [~, ~] = TFS_plotFit(result_FM, dataColor, lineColor, plotOrNot, plotData, threshType, 'fdev [dB re: 1 Hz]');

% ILD
% result1_ILD = psignifit(data_group1_ILD,options);
% result2_ILD = psignifit(data_group2_ILD,options);
% result_ILD = psignifit(data_group_ILD,options);

% if plotOrNot
%     figure(); 
% end
% [~, percent_std_jk_ILD1, ~, thresh_std_jk_ILD1, ~] = TFS_std(data1_ILD, size(data1_ILD, 1), options, dataColor, lineColor, threshType);
% [~, ~] = TFS_plotFit(result1_ILD, dataColor1, lineColor1, plotOrNot, plotData, threshType, 'ILD [dB]', percent_std_jk_ILD1, thresh_std_jk_ILD1);
% [~, percent_std_jk_ILD2, ~, thresh_std_jk_ILD2, ~] = TFS_std(data2_ILD, size(data2_ILD, 1), options, dataColor, lineColor, threshType);
% [~, ~] = TFS_plotFit(result2_ILD, dataColor2, lineColor2, plotOrNot, plotData, threshType, 'ILD [dB]', percent_std_jk_ILD2, thresh_std_jk_ILD2); 

% if plotOrNot
%     figure();
% end
% [~, percent_std_jk_ILD, ~, thresh_std_jk_ILD, ~] = TFS_std(data_ILD, numel(idx_all), options, dataColor, lineColor, threshType);
% [~, ~] = TFS_plotFit(result_ILD, dataColor, lineColor, plotOrNot, plotData, threshType, 'ILD [dB]', 1.96*percent_std_jk_ILD, 1.96*thresh_std_jk_ILD);

% % ITD
% % result1_ITD = psignifit(data_group1_ITD,options);
% % result2_ITD = psignifit(data_group2_ITD,options);
result_ITD = psignifit(data_group_ITD,options);
% % if plotOrNot
% %     figure(); 
% % end
% % [~, percent_std_jk_ITD1, ~, thresh_std_jk_ITD1, ~] = TFS_std(data1_ITD, size(data1_ITD, 1), options, dataColor, lineColor, threshType);
% % [~, ~] = TFS_plotFit(result1_ITD, dataColor1, lineColor1, plotOrNot, plotData, threshType, 'ITD [us]', percent_std_jk_ITD1, thresh_std_jk_ITD1);
% % [~, percent_std_jk_ITD2, ~, thresh_std_jk_ITD2, ~] = TFS_std(data2_ITD, size(data2_ITD, 1), options, dataColor, lineColor, threshType);
% % [~, ~] = TFS_plotFit(result2_ITD, dataColor2, lineColor2, plotOrNot, plotData, threshType, 'ITD [us]', percent_std_jk_ITD2, thresh_std_jk_ITD2); 
% 
if plotOrNot
    figure(); 
end
[~, percent_std_jk_ITD, ~, thresh_std_jk_ITD, ~] = TFS_std(data_ITD, size(data_ITD, 1), options, dataColor, lineColor, threshType);
[~, ~] = TFS_plotFit(result_ITD, dataColor, lineColor, plotOrNot, plotData, threshType, 'ITD [us]', 1.96*percent_std_jk_ITD, 1.96*thresh_std_jk_ITD); 
end