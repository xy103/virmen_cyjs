function vr = updateLivePlots(vr)
    % Update online behavioral metric plots
    behavData = vr.behaviorData(:,1:vr.trialIterations);
    vr.livePlotFig;
    rew_delay_start_ix = find(behavData(8,:) == -1,1); 
    x = behavData(5,1:rew_delay_start_ix);
    y = behavData(6,1:rew_delay_start_ix);
    t = cumsum(behavData(10,:));
    rew_delay_start = t(rew_delay_start_ix);
    ITI_start = t(find(behavData(8,:) == 1,1));
    lick_trace = behavData(7,:);
    %     [lick_v,lick_ix] = findpeaks(lick_trace,'minPeakHeight',vr.livePlot_opt.minLickV);
    lick_ix = find(lick_trace >= vr.livePlot_opt.lickV);
    lick_y = y(lick_ix(lick_ix < length(y))); % y does not extend into the ITI
    lick_t = t(lick_ix); 
    lick_v = lick_trace(lick_ix); 
    n_licks = length(lick_y); % note that this ends at trial end 
    
    vr.trial_world_lickY = [vr.trial_world_lickY ; ...
                ones(n_licks,1) + vr.numTrials zeros(n_licks,1) + vr.currentWorld lick_y']; 
%     rew_time = t(behavData(9,:) == 1); 
    
    % Lick trace from last trial
    subplot(2,2,1);cla
%     plot(y,lick_trace,'color',[.2,.8,.2],'linewidth',1) % lick signal
    plot(t,lick_trace,'color',[.2,.8,.2],'linewidth',1) % lick signal
    scatter(lick_t,lick_v,10,[0,0,0]) % estimated lick event signals
    % add patches to indicate trial interval
    v_ISI = [0 -1; 0 0; rew_delay_start 0; rew_delay_start -1];
    v_delay = [rew_delay_start -1; rew_delay_start 0; ITI_start 0; ITI_start -1]; 
    v_ITI = [ITI_start -1; ITI_start 0; t(end) 0; t(end) -1]; 
    patch('Faces',[1 2 3 4],'Vertices',v_ISI,'FaceColor',[1 1 1]);
    patch('Faces',[1 2 3 4],'Vertices',v_delay,'FaceColor',[.5 .5 .5],'FaceAlpha',.5);
    patch('Faces',[1 2 3 4],'Vertices',v_ITI,'FaceColor',[.2 .2 .2],'FaceAlpha',.5);
    ylim([-1 5]); 
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

