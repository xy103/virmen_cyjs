function vr = plot_lick(vr)
    behavData = vr.behaviorData(:,1:vr.trialIterations);
    t = cumsum(behavData(10,:));
    lick_trace = behavData(7,:);
    
    % plot lick
    figure(vr.lickFig);cla
    plot(t,lick_trace,'color',[.2,.8,.2],'linewidth',1); % lick signal

    ylim([-1 5]); 
    title(sprintf("Trial %i Lick Behavior",vr.numTrials+1))
    xlabel("Time")
    ylabel("Lick Deflection Voltage")
end

