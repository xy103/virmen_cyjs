function switching_summary_visualization(session_data,parameters)

    %% plot settings
    lickV = 0.5; % voltage for lick detection
    pre_switch = 10; 
    post_switch = 50; 
    % set up colors and trial type indicators for lick raster plot
    ylOrBr = cbrewer('seq','YlOrBr',10,'spline'); 
    greys = cbrewer('seq','Greys',10,'spline'); 
    blues = cbrewer('seq','Blues',10,'spline');
    reds = cbrewer('seq','Reds',10,'spline');
    blue = blues(8,:); 
    red = reds(8,:); 
    grey = greys(8,:);
    brown = ylOrBr(8,:); 
    worldColors = [blue ; blue ; red ; red ; grey ; grey ; brown ; brown]; % trial type colors for lick raster 
    worldSymbols = '.x.x.x.x.x.x.x.x'; % trial type symbols for lick raster 
    rewardColors = [0 0 0 ;0.0353    0.7255    0.2510]; 
    rewardSymbols = '.x'; 
    total_iti_time = str2num(parameters.rewardDelay) + max(str2num(parameters.itiCorrect),str2num(parameters.itiMissBase));
    maze_len = str2num(parameters.floorLength) + str2num(parameters.funnelLength); 

    % Collect useful data together
    world_signal = session_data(1,:); 
    block_signal = session_data(4,:); 
    x = session_data(5,:);
    position = session_data(6,:); 
    lick_trace = session_data(7,:); 
    iti_signal = session_data(8,:); 
    reward_signal = session_data(9,:); 
    t = cumsum(session_data(10,:)); 
    trial_num = session_data(14,:);

    n_trials = max(trial_num); 

    % Find trial phase indices
    trial_onset = [1 find(diff(trial_num) == 1)]; 
    delay_onset = find(iti_signal == -2); 
    if isempty(delay_onset) % catch feedback delay dependent signal logging difference 
        delay_onset = find((iti_signal(1:end-1) == 0) & (diff(iti_signal) == -1)); 
    end
    iti_onset = find((iti_signal(1:end-1) == 0) & (diff(iti_signal) == 1)); 
    iti_offset = [trial_onset(2:end) size(session_data,2)]; 

    % Per trial data
    reward = reward_signal(iti_onset); 
    world = world_signal(trial_onset + 1); 
    right_worlds = [1 3 5 7]; checker_worlds = 5:8; 
    right_world = ismember(world,right_worlds);
    checker_world = ismember(world,checker_worlds); 
    block = block_signal(trial_onset); 
    choices = strings(size(block)); 
    choices(x(iti_onset) > 0) = "R"; 
    choices(x(iti_onset) < 0) = "L"; 
    switches = find(diff(block) ~= 0);

    % Get data computed for lick raster visualization
    lick_ix = find(lick_trace > lickV); 
    lick_ix_maze = arrayfun(@(i_trial) lick_ix(lick_ix > trial_onset(i_trial) & lick_ix < delay_onset(i_trial)),(1:n_trials)','un',0); 
    lick_positions_trialed = cellfun(@(trial_licks) position(trial_licks),lick_ix_maze,'un',0); 
    maze_tnums_trialed = arrayfun(@(i_trial) i_trial + zeros(length(lick_positions_trialed{i_trial}),1),(1:n_trials)','un',0); 
    maze_tts_trialed = arrayfun(@(i_trial) 1 + reward(i_trial) + zeros(length(lick_positions_trialed{i_trial}),1),(1:n_trials)','un',0); 

    lick_ix_iti = arrayfun(@(i_trial) lick_ix(lick_ix > delay_onset(i_trial) & lick_ix < iti_offset(i_trial)),(1:n_trials)','un',0); 
    lick_times_trialed = arrayfun(@(i_trial) t(lick_ix_iti{i_trial}) - t(delay_onset(i_trial)),(1:n_trials)','un',0);  
    iti_tnums_trialed = arrayfun(@(i_trial) i_trial + zeros(length(lick_times_trialed{i_trial}),1),(1:n_trials)','un',0); 
    iti_tts_trialed = arrayfun(@(i_trial) 1 + reward(i_trial) + zeros(length(lick_times_trialed{i_trial}),1),(1:n_trials)','un',0); 

    f = figure('Position', [300 300 600 400] + 100); 
    % f.Position(1:2) = [800 600]; 
    % initialize plots
    % Lick raster plot
    subplot(8,8,[1:3 9:11 17:19 25:27]);hold on 
    custom_gscatter(cat(2,lick_positions_trialed{:}),cat(1,maze_tnums_trialed{:}),cat(1,maze_tts_trialed{:}),rewardColors,rewardSymbols,3);
    xlabel("Position (cm)") 
    ylabel("Trial #")
    xlim([5,maze_len + 5])
    ylim([0,n_trials])
    set(gca, 'YDir','reverse')
    title("Lick Raster Plot")
    subplot(8,8,[4 12 20 28]);hold on
    custom_gscatter(cat(2,lick_times_trialed{:}),cat(1,iti_tnums_trialed{:}),cat(1,iti_tts_trialed{:}),rewardColors,rewardSymbols,3);
    xlabel("Time in ITI (sec)") 
    ylim([0,n_trials]) 
    yticks([])
    xlim([0,total_iti_time]) 

    % Get data together for performance plot
    if str2num(parameters.fractionNoChecker) == 1
        subplot(2,2,2)
        plot(smoothdata(reward,'gaussian',10),'k','linewidth',1.5)
        title("Performance")
        subplot(2,2,4)
        cla; hold on;
        rewards_L = reward; 
        rewards_L(right_world == 1) = nan; 
        rewards_R = reward; 
        rewards_R(right_world == 0) = nan; 
        plot(smoothdata(rewards_L,'gaussian',10),'b','linewidth',1)
        plot(smoothdata(rewards_R,'gaussian',10),'r','linewidth',1)
        legend("L World","R World",'AutoUpdate','off','Location','SouthWest')
        xlabel("Trial Number")
        title("Performance Split by Correct Choice")

        for i_subplot = 1:2
            subplot(2,2,2 * i_subplot)
            xlim([0 n_trials])
            ylim([0 1])
            yline(.5,':')
            if ~isempty(switches)
                xline(switches,'linewidth',1.5,'color',[.5 .5 .5]);
            end
        end
    else
        subplot(3,2,2)
        plot(smoothdata(reward,'gaussian',10),'k','linewidth',1.5)
        subplot(3,2,4)
        cla; hold on;
        rewards_L = reward; 
        rewards_L(right_world == 1) = nan; 
        rewards_R = reward; 
        rewards_R(right_world == 0) = nan; 
        plot(smoothdata(rewards_L,'gaussian',15),'b','linewidth',1)
        plot(smoothdata(rewards_R,'gaussian',15),'r','linewidth',1)
        legend("L World","R World",'AutoUpdate','off')
        subplot(3,2,6)
        cla; hold on;
        rewards_checker = reward; 
        rewards_checker(checker_world == 0) = nan; 
        rewards_noChecker = reward; 
        rewards_noChecker(checker_world == 1) = nan;
        plot(smoothdata(rewards_checker,'gaussian',15),'k:','linewidth',1)
        plot(smoothdata(rewards_noChecker,'gaussian',15),'k-','linewidth',1)
        legend("Checker","NoChecker",'AutoUpdate','off'); 

        for i_subplot = 1:3
            subplot(3,2,2 * (i_subplot))
            xlim([0 n_trials])
            ylim([0 1])
            yline(.5,':')
            if ~isempty(switches)
                xline(switches,'linewidth',1.5,'color',[.5 .5 .5]);
            end
        end
    end

    % now show switches
    switch_reward = cell(numel(switches),1); 
    subplot(2,2,3);hold on
    for i_switch = 1:numel(switches)
        this_switch = switches(i_switch); 
        switch_reward{i_switch} = reward(max(1,this_switch - pre_switch) : min(n_trials,this_switch + post_switch));
        switch_reward{i_switch} = [nan(1,min(0,pre_switch - this_switch)) switch_reward{i_switch} nan(1,max(0,this_switch + post_switch - n_trials))]; 
    %     plot(smoothdata(switch_reward{i_switch},2,'gaussian',15),'color',[.5 .5 .5],'linewidth',1)
    end

    plot(smoothdata(cat(1,switch_reward{:}),2,'gaussian',10)','color',[.5 .5 .5],'linewidth',1)
    plot(smoothdata(mean(cat(1,switch_reward{:})),'gaussian',10),'color','k','linewidth',2)
    xline(pre_switch,'k--')
    xticks([0 pre_switch pre_switch + post_switch / 2 pre_switch + post_switch])
    xticklabels([0 pre_switch pre_switch + post_switch / 2 pre_switch + post_switch] - pre_switch)
    xlabel("Trials since switch")

end