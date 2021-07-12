function vr = updateLivePlots(vr)
    % Update online behavioral metric plots
    trial_start = find(vr.behaviorData(8,:) == 0,1); % after ITI
    behavData = vr.behaviorData(:,trial_start:vr.trialIterations);
    vr.livePlotFig;
    x = behavData(5,:); 
    y = behavData(6,:); 
    lick_trace = behavData(7,:); 
    [lick_v,lick_ix] = findpeaks(lick_trace,'minPeakHeight',vr.livePlot_opt.minLickV);
    lick_y = y(lick_ix); 
    n_licks = length(lick_ix); 
    
    vr.trial_world_lickY = [vr.trial_world_lickY ; ...
                ones(n_licks,1) + vr.numTrials zeros(n_licks,1) + vr.currentWorld lick_y']; 
    t = cumsum(behavData(10,:)); 
%     rew_time = t(behavData(9,:) == 1); 
    
    % Lick trace from last trial
    subplot(2,2,1);cla
%     plot(y,lick_trace,'color',[.2,.8,.2],'linewidth',1) % lick signal
    plot(t,lick_trace,'color',[.2,.8,.2],'linewidth',1) % lick signal
%     scatter(lick_y,lick_v,10,[0,0,0]) % estimated lick event signals
    title(sprintf("Trial %i Lick Behavior",vr.numTrials+1))
    
    % Lick raster colored by trial type
    subplot(2,2,3); cla
    gscatter(vr.trial_world_lickY(:,3),vr.trial_world_lickY(:,1),vr.trial_world_lickY(:,2),vr.livePlot_opt.worldColors,[],5)
    set(gca, 'YDir','reverse')
    ylim([0 max(vr.livePlot_opt.initRasterMaxTrials,vr.numTrials)])
    
    % Plot position traces colored by trial type
    subplot(2,2,[2 4])
    if vr.numTrials > 0
        children = get(gca, 'children');
        delete(children(1)); % delete last trace
        plot(vr.prev_x,vr.prev_y,'color',vr.livePlot_opt.worldColors(vr.prev_world,:),'linewidth',.5)
    end
    plot(x,y,'color',vr.livePlot_opt.worldColors(vr.currentWorld,:),'linewidth',1.5)
    vr.prev_x = x; 
    vr.prev_y = y; 
    vr.prev_world = vr.currentWorld; 
     
end

