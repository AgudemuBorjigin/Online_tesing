function ax = TFS_groupbar(mr1, mr2, group_legend, numSubj1, numSubj2, greater, collapse, overlap)
mean1 = mean(mr1);
mean2 = mean(mr2);
var1 = var(mr1)*(numSubj1-1);
var2 = var(mr2)*(numSubj2-1);
error1 = sqrt(var1);
error2 = sqrt(var2);
if collapse
    
    var1_mean = 1/(sum(1./var1));% if conditions are independent
    var2_mean = 1/(sum(1./var2));
%     error1 = [error1, sqrt(var1_mean)];
%     error2 = [error2, sqrt(var2_mean)];
%     mean1 = [mean1, mean(mean1)];
%     mean2 = [mean2, mean(mean2)];
    error1 = [sqrt(var1_mean), 0];
    error2 = [sqrt(var2_mean), 0];
    mean1 = [sum(mean1./var1)/sum(1./var1), 0];
    mean2 = [sum(mean2./var2)/sum(1./var2), 0];
end
mean_group = [mean1', mean2'];
error_group = [error1', error2'];
% two-sample t-test between two groups
nconds = size(mean1, 2);
p = zeros(nconds, 1);
Z = zeros(nconds, 1);
for i = 1:nconds
    % remove n1, n2, one-tail
    Z(i) = (mean1(i) - mean2(i)-0)/sqrt(error1(i)^2+error2(i)^2);
    %Z = (mean1-mean2-0)/sqrt(std2^2/n1+std2^2/n2);
    if greater
        p(i) = (1-normcdf(Z(i)));
    else
        p(i) = 1-(1-normcdf(Z(i)));
    end
end

Y = mean_group;
E = error_group;
C = [1 0 0;
    0 0 1];
% significance
P = nan(numel(Y), numel(Y));
for i = 1:nconds
    if p(i) <= 0.05
        P(i, i+nconds) = p(i);
    end
end
% Make P symmetric, by copying the upper triangle onto the lower triangle
PT = P';
lidx = tril(true(size(P)), -1);
P(lidx) = PT(lidx);
if overlap
    ax = superbar(Y, 'E', E, 'P', P, 'BarFaceColor', 'none', 'ErrorbarLineWidth', 3, 'PLineWidth', 3, 'PStarFontSize', 24);
else
    ax = superbar(Y, 'E', E, 'P', P, 'BarFaceColor', 'none', 'BarEdgeColor', permute(C, [3 1 2]), 'ErrorbarLineWidth', 3, 'PLineWidth', 3, 'PStarFontSize', 24);
end
end