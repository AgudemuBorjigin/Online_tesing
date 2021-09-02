function [h, thresh] = TFS_plotFit(result, dataColor, lineColor, plotOrNot, plotData, type, xlabeltxt, error, error_thresh)
lineWidth       = 2;
extrapolLength  = .2;
%% threshold
if contains(type, 'TFS')
    thresh = result.Fit(1); % considers guessing/lapse rate
else
    thresh = getThreshold(result,0.5); % doesn't consider guessing/lapse rate
end
if plotOrNot
    %% plot data
    if plotData
        dataSize  = 10000./sum(result.data(:,3));
        for i = 1:size(result.data, 1)
            h = plot(result.data(i,1),result.data(i,2)./result.data(i,3),'.','MarkerSize',sqrt(dataSize*result.data(i,3)),'Color',dataColor);
            hold on;
            errorbar(result.data(i,1),result.data(i,2)./result.data(i,3), error(i),'-', 'Color',dataColor, 'LineWidth',lineWidth);
        end
    end
    %% plot fitted function
    % log scale should be used in cases where: sigmoidName is {'Weibull','logn','weibull'}
    xlength   = max(result.data(:,1))-min(result.data(:,1));
    x         = linspace(min(result.data(:,1)),max(result.data(:,1)),1000);
    xLow      = linspace(min(result.data(:,1))-extrapolLength*xlength,min(result.data(:,1)),100);
    xHigh     = linspace(max(result.data(:,1)),max(result.data(:,1))+extrapolLength*xlength,100);
    fitValuesLow    = (1-result.Fit(3)-result.Fit(4))*arrayfun(@(x) result.options.sigmoidHandle(x,result.Fit(1),result.Fit(2)),xLow)+result.Fit(4);
    fitValuesHigh   = (1-result.Fit(3)-result.Fit(4))*arrayfun(@(x) result.options.sigmoidHandle(x,result.Fit(1),result.Fit(2)),xHigh)+result.Fit(4);
    fitValues = (1-result.Fit(3)-result.Fit(4))*arrayfun(@(x) result.options.sigmoidHandle(x,result.Fit(1),result.Fit(2)),x)+result.Fit(4);
    if plotData
        h = plot(x, fitValues,'Color', lineColor,'LineWidth',lineWidth);
    else
        h = plot(x, fitValues,'Color', lineColor,'LineWidth',lineWidth);
    end
    hold on;
    plot(xLow,  fitValuesLow,'--',  'Color', lineColor,'LineWidth',lineWidth)
    plot(xHigh, fitValuesHigh,'--', 'Color', lineColor,'LineWidth',lineWidth)
    %% parameters
    switch result.options.expType
        case {'nAFC'}
            ymin = 1./result.options.expN;
            ymin = min(ymin,min(result.data(:,2)./result.data(:,3)));
            ymin = ymin - 0.1;
        otherwise
            ymin = 0;
    end
    % threshold
    plot([result.Fit(1),result.Fit(1)],[ymin+0.01,result.Fit(4)+(1-result.Fit(3)-result.Fit(4)).*result.options.threshPC],'--','Color',lineColor, 'LineWidth',lineWidth);
    plot([min(xLow),result.Fit(1)],repmat(result.Fit(4)+(1-result.Fit(3)-result.Fit(4)).*result.options.threshPC, 1, 2),'--','Color',lineColor, 'LineWidth',lineWidth);
    hold on;
    % asymptotes
    plot([min(xLow),max(xHigh)],[1-result.Fit(3),1-result.Fit(3)],':','Color',lineColor, 'LineWidth',lineWidth);
    plot([min(xLow),max(xHigh)],[result.Fit(4),result.Fit(4)],':','Color',lineColor, 'LineWidth',lineWidth);
    % CI
    %plot(result.conf_Intervals(1,:,1),repmat(result.Fit(4)+result.options.threshPC*(1-result.Fit(3)-result.Fit(4)),1,2),'Color',lineColor)
    %plot(repmat(result.conf_Intervals(1,1,1),1,2),repmat(result.Fit(4)+result.options.threshPC*(1-result.Fit(3)-result.Fit(4)),1,2)+[-.01,+.01],'Color',lineColor)
    %plot(repmat(result.conf_Intervals(1,2,1),1,2),repmat(result.Fit(4)+result.options.threshPC*(1-result.Fit(3)-result.Fit(4)),1,2)+[-.01,+.01],'Color',lineColor)
    % STD
    plot(repmat(result.Fit(1)-error_thresh, 1, 2), [ymin+0.02, ymin],'Color',lineColor, 'LineWidth',lineWidth);
    plot(repmat(result.Fit(1)+error_thresh, 1, 2), [ymin+0.02, ymin],'Color',lineColor, 'LineWidth',lineWidth);
    plot([result.Fit(1)-error_thresh, result.Fit(1)+error_thresh], [ymin+0.01, ymin+0.01],'Color',lineColor, 'LineWidth',lineWidth);
    %errorbar(result.Fit(1), ymin, error1, '-', 'Color',dataColor)
    %% axis
    fontSize       = 15;
    labelSize      = 15;
    fontName       = 'Helvetica';
    xLabel         = xlabeltxt;
    yLabel         = 'Percent Correct with 95% CI';
    axis tight
    set(gca,'FontSize',fontSize)
    if strcmp(xlabeltxt, 'ILD [dB]')
        xticks([-20.0000, -13.9794, -7.9588, -1.9382, 4.0824, 10.1030])
        xticklabels({'0.1', '0.2', '0.4', '0.8', '1.6', '3.2'})
    elseif strcmp (xlabeltxt, 'ITD [us]')
        xticks([6.0206 12.0412 18.0618 24.0824 30.1030 36.1236 42.1442])
        xticklabels({'2', '4', '8', '16', '32', '64', '128'})
    end
    yticks([0.4 0.5 0.6 0.7 0.8 0.9 1])
    yticklabels({'40', '50', '60', '70', '80', '90', '100'})
    ylabel(yLabel,'FontName',fontName,'FontSize', labelSize);
    xlabel(xLabel,'FontName',fontName,'FontSize', labelSize);
    ylim([ymin,1]);
    set(gca,'TickDir','out')
    grid on;
    box off
else
    h = 0;
end
end