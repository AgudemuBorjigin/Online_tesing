function [idx_all, C] = TFS_clustering(data_pairs, idx_good, color)
%data_pairs = [thresh_ITD(idx_good)', thresh_FM(idx_good)', thresh_ILD(idx_good)'];
%idx = kmeans(data_pairs, 3);
%scatter3(data_pairs(:,1), data_pairs(:,2), data_pairs(:,3), 15, idx, 'filled');
figure();
ax = gca;
numCluster = 2;
numVar = numel(data_pairs(1,:));
[idx, C] = kmeans(data_pairs, numCluster);
for i = 1:numCluster
    if numVar > 1
        plot(data_pairs(idx==i, 1), data_pairs(idx==i, 2), 'Color', color(i), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 18);
        hold on;
        plot(C(i,1),C(i,2),'kx', 'MarkerSize',22,'LineWidth',3);
else
        plot(data_pairs(idx==i), 'Color', color(i), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 18);
        hold on;
        plot(50, C(i),'kx','MarkerSize',22,'LineWidth',3);
    end
end
if numVar > 1
    mdl = fitlm(data_pairs(:, 1), data_pairs(:, 2));
    slope = mdl.Coefficients.Estimate(2);
    intersect = mdl.Coefficients.Estimate(1);
    x0 = min(data_pairs(:, 1));
    x1 = max(data_pairs(:, 1));
    x = linspace(x0, x1);
    y = slope*x + intersect;
    plot(x, y, 'k', 'LineWidth', 2);
    dim = [.2 .5 .3 .3];
    str = {['P = ', 32, num2str(round(mdl.Coefficients.pValue(2),7))],...
       ['R =', 32, num2str(round(sqrt(mdl.Rsquared.Ordinary), 2))],...
       ['n =', 32, num2str(numel(data_pairs(:,1)))]};
    annotation('textbox',dim,'String',str, 'FitBoxToText','on', 'FontSize', 16);
    title 'Cluster assignment based on the ITD&FM thresholds'
    xlabel('ITD [residual]');
    ylabel('fdev [residual]');
else
    title 'Cluster assignment based on the ILD thresholds'
    ylabel('ILD [dB]');
    set(ax,'XTick',[])
end
set(ax, 'FontSize', 24);
hold off
% padding idx
idx_all = 100*ones(1,numel(data_pairs(:,1)));
j = 0;
for i = idx_good
    j = j + 1;
    idx_all(i) = idx(j);
end
legend('Group1', 'Centroids', 'Group2', 'Location','best')
end