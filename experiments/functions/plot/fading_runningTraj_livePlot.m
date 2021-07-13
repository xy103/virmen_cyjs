function vr = fading_runningTraj_livePlot(vr)
%% Plot position trajectories color-coded by trial type, fading over time
    behavData = vr.behaviorData(:,1:vr.trialIterations);
    rew_delay_start_ix = find(behavData(8,:) == -1,1); 
    x = behavData(5,1:rew_delay_start_ix);
    y = behavData(6,1:rew_delay_start_ix);
    this_world = vr.currentWorld;

    % update live_saved_xy
    if numel(vr.live_saved_xy{this_world}) < vr.livePlot_opt.n_save_trials % append if fewer than save trials
        vr.live_saved_xy{this_world} = [vr.live_saved_xy{this_world} ; {[x' y']}];
    else % else cirshift to pop
        vr.live_saved_xy{this_world} = circshift(vr.live_saved_xy{this_world},1);
        vr.live_saved_xy{this_world}{1} = [x' y'];
    end

    % now prepare the colormap
    n_trials_world = cellfun(@length,vr.live_saved_xy);
    new_cmap = [];
    for i_world = 1:vr.nWorlds
        % this weird stuff is due to how cbrewer works
        i_world_colors = flipud(cbrewer('seq',vr.livePlot_opt.color_gradient_order(i_world),max(3,n_trials_world(i_world)),'spline'));
        i_world_colors = i_world_colors(end-n_trials_world(i_world)+1:end,:);
        new_cmap = [new_cmap ; i_world_colors];
    end
    % update color order
    set(gca, 'ColorOrder', new_cmap, 'NextPlot', 'replacechildren');
    cla;hold on

    % plot
    for i_world = 1:vr.nWorlds
        arrayfun(@(i_trial) plot(vr.live_saved_xy{i_world}{i_trial}(:,1),vr.live_saved_xy{i_world}{i_trial}(:,2)),(1:n_trials_world(i_world)));
    end

end

