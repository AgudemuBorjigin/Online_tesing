clear;
path = '/Users/Agudemu/Dropbox/Lab_SNAP/Experiment/online_experiments/snaplabonline/Online_tesing/analysis_scripts/';
% settings for the Bayesian estimate functions
options = struct;
options.sigmoidName = 'norm'; % choose a cumulative Gaussian as the sigmoid
options.expType     = 'nAFC'; % choose n-AFC as the paradigm of the experiment
options.expN = 2;
dataColor = [0, 0, 0];
lineColor = dataColor;
threshType = 'TFS';

%% ITD, loading the data extracted from the json file (by Python script—analysis_ITD.py)
load(strcat(path, 'data_ITD.mat'));
data_ITD = double(data);
thresh_ITD = zeros(1, size(subjNames,1));
for i = 1:size(subjNames,1)
    % calculating the thresholds based on Bayetian method
    result = psignifit(squeeze(data_ITD(i, :, :)),options);
    % threshold_type—"TFS" the threshold estimate considers the lapse
    % rate/guessing
    [~, thresh_ITD(i)] = TFS_plotFit(result, dataColor, lineColor, 0, 0, threshType); 
end
%% FM
load(strcat(path, 'data_FM.mat'));
data_FM = double(data);
thresh_FM = zeros(1, size(subjNames,1));
for i = 1:size(subjNames,1)
    result = psignifit(squeeze(data_FM(i, :, :)),options);
    [~, thresh_FM(i)] = TFS_plotFit(result, dataColor, lineColor, 0, 0, threshType);
end
%% ILD
load(strcat(path, 'data_ILD.mat'));
data_ILD = double(data);
thresh_ILD = zeros(1, size(subjNames,1));
for i = 1:size(subjNames,1)
    result = psignifit(squeeze(data_ILD(i, :, :)),options);
    [~, thresh_ILD(i)] = TFS_plotFit(result, dataColor, lineColor, 0, 0, threshType);
end
%% residual
% regression models, alternative woudl be to use fitlm
mdl_FM = stepwiselm(thresh_ILD, thresh_FM); % modeling FM thresholds based on ILD thresholds
mdl_ITD = stepwiselm(thresh_ILD, thresh_ITD);
mdl_ILD = stepwiselm([thresh_ITD', thresh_FM'], thresh_ILD'); % modeling ILD thresholds based on ITD and FM thresholds
% taking the residuals
resid_FM = mdl_FM.Residuals.Raw + mdl_FM.Coefficients.Estimate(1);
resid_ITD = mdl_ITD.Residuals.Raw + mdl_ITD.Coefficients.Estimate(1);
resid_ILD = mdl_ILD.Residuals.Raw + mdl_ILD.Coefficients.Estimate(1);
savename = '/Users/Agudemu/Dropbox/Lab_SNAP/Experiment/online_experiments/snaplabonline/Online_tesing/analysis_scripts/psignifit/TFS_beforeGrouping.mat';
save(savename, 'resid_ITD', 'resid_FM', 'resid_ILD', ...
    'data_FM', 'data_ILD', 'data_ITD', ...
    'thresh_ITD', 'thresh_FM', 'thresh_ILD');
% 'percent_std_ILD', 'thresh_std_ILD', 'percent_std_ITD', 'thresh_std_ITD', 'percent_std_FM', 'thresh_std_FM',...
% 'percent_std_jk_ILD', 'thresh_std_jk_ILD', 'percent_std_jk_ITD', 'thresh_std_jk_ITD', 'percent_std_jk_FM', 'thresh_std_jk_FM', ...
% 'thresh_jk_ILD', 'thresh_jk_ITD', 'thresh_jk_FM'
%% Grouping
TFS_grouping(resid_ITD, resid_FM, resid_ILD, data_ITD, data_FM, data_ILD, options, threshType);