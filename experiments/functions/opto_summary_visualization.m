function opto_summary_visualization(sessionData,parameters,optoData)
%% plot settings
% mazeOpto: light starts ramping in the previous trial's ITI and
% persists during current trial's maze (time and position both relevant)
% should separate by cue and rule type
% itiOpto: light starts ramping in the current trial's waiting period
% for feedback and continues into ITI (only time relevant)
% should separate by turn type

is_maze_opto = contains(parameters.name,'maze'); % inidicator to set up plots
is_funnel_opto = contains(parameters.name,'funnel');

% set up colors and account for cue and turn pairings
[paired_map] = cbrewer('qual', 'Paired', 8); % 4 pairs of colors
opto_colors = paired_map(1:2:end,:);
normal_colors = paired_map(2:2:end,:); % lighter colors of matched trial types
% 1 - WR, 2 - WL, 3 - BR, 4 - BL
% 5 - cWR, 6 - cWL, 7 - cBR, 8 - cBL
world_names = {'WR', 'WL','BR','BL'};

% Collect useful data together
maze_len = str2double(parameters.variables.floorLength) + str2double(parameters.variables.funnelLength);
rewardLength = 5 + maze_len;
ramp_up_dur = str2double(parameters.variables.optoRampUpDur);
ramp_down_dur = str2double(parameters.variables.optoRampDownDur);
ramp_sus_dur = str2double(parameters.variables.optoLightDur);
opto_dur = ramp_up_dur + ramp_down_dur + ramp_sus_dur;

% in case last opto trial is not saved
optoData.optoEndIter = optoData.optoEndIter(optoData.optoEndIter<size(sessionData,2));
optoData.optoStartIter = optoData.optoStartIter(1:length(optoData.optoEndIter));

lat_vel = sessionData(2,:);
forw_vel = sessionData(3,:);
forw_pos = sessionData(6,:); % may need to cap at 205
tm_bin_size = .05;
tm_bin_edges = -tm_bin_size/2:tm_bin_size:opto_dur+tm_bin_size/2;
tm_bin_ctrs = tm_bin_edges(1:end-1)+tm_bin_size/2;
start_pos=10; end_pos = 205;
pos_bin_size = 5;
pos_bin_edges = -pos_bin_size/2:pos_bin_size:end_pos+pos_bin_size/2;
pos_bin_ctrs = pos_bin_edges(1:end-1)+pos_bin_size/2;

ts = cumsum(sessionData(10,:)); % timestamp
iter_trial = sessionData(end,:);
% opto start and end should be the same if ITI opto
% opto_start_trials = sessionData(end,optoData.optoStartIter);
opto_end_trials = iter_trial(optoData.optoEndIter); % opto always end on the trial we want to perturb
opto_start_tm = ts(optoData.optoStartIter);
% opto_end_tm = ts(optoData.optoEndIter);
% all trials
all_trials = unique(iter_trial);
normal_trials = all_trials(~ismember(all_trials,opto_end_trials));
trial_rewarded = zeros(size(all_trials));
trial_turn = zeros(size(all_trials));
all_world_type = zeros(size(all_trials));
for i = 1:length(all_trials)
    trial_rewarded(i) = sum(sessionData(9,sessionData(15,:)==all_trials(i)))>0;
    trial_turned_R = sessionData(5,sessionData(15,:)==all_trials(i));
    trial_turn(i) = trial_turned_R(end)>0;
    all_world_type(i) = sessionData(1,find(sessionData(15,:)==all_trials(i),1));
end
opto_world_type = all_world_type(opto_end_trials);
normal_world_type = all_world_type(normal_trials);
% find comparable conditions in non-opto normal trials
normal_trials_comp_start_tm = zeros(size(normal_trials));
for i = 1:length(normal_trials)
    trial_tm = ts(iter_trial==normal_trials(i));
    if is_maze_opto % CY 10/16/2023 corrected logic to go backwards from trial start time
        normal_trials_comp_start_tm(i) = trial_tm(1) - ramp_up_dur;
    elseif is_funnel_opto
        trial_pos = forw_pos(iter_trial==normal_trials(i));
        normal_trials_comp_start_tm(i) = trial_tm(find(trial_pos>=str2num(parameters.variables.optoTriggerPos),1));
    else % light starts while waiting for feedback and reward
        normal_trials_comp_start_tm(i) = trial_tm(find(sessionData(6,iter_trial==normal_trials(i))>=rewardLength,1));
    end
end

%%
% we already know when opto starts and ends (in iters) from optoData
title_options = {'Lateral','Forward'};
opto_names = {'Normal','Opto'};
plot_maze_pos = is_maze_opto || is_funnel_opto;
n_col = 3+2*plot_maze_pos;
f = figure('Position', [300 200 900+plot_maze_pos*2*300 750]); % if is_maze_opto allow space for two extra columns
ax_tm = gobjects(6,1); % shared by both plots

if is_maze_opto
    sgtitle({'Maze Inhibition','Opto ramps up in the previous ITI for 0.5s'})
    ax_pos = gobjects(6,1);
elseif is_funnel_opto
    sgtitle({'Funnel Inhibition','Opto ramps up after position 80 (half way of stem)'})
    ax_pos = gobjects(6,1);
else
    sgtitle({'ITI Inhibition','Opto ramps up while waiting for visual feedback for 0.5s'})
end

% we want to plot forward and lateral velocity with opto on and off (x axis is time)
for vel_ind = 1:2
    if vel_ind ==1
        vel_touse = lat_vel;
    else
        vel_touse = forw_vel;
    end

    for is_opto = 0:1
        save_tm_pts = {};
        save_vel = {};
        for j = 1:4
            save_tm_pts{j} = [];
            save_vel{j} = [];
        end

        if is_opto == 0
            trials_to_plot = normal_trials;
            reference_start_time = normal_trials_comp_start_tm;
            relevant_world_type = normal_world_type;
            colors_to_use = normal_colors;
        else
            trials_to_plot = opto_end_trials;
            reference_start_time = opto_start_tm;
            relevant_world_type = opto_world_type;
            colors_to_use = opto_colors;
        end

        ax_tm(vel_ind+is_opto*2) = subplot(3,n_col,vel_ind+n_col*is_opto);hold on
        % plotting trial by trial
        for i = 1:length(trials_to_plot)
            if is_opto==0
                relevant_ind = ts>=normal_trials_comp_start_tm(i)&(ts<normal_trials_comp_start_tm(i)+opto_dur);
            else
                relevant_ind = optoData.optoStartIter(i):optoData.optoEndIter(i);
            end
            temp_tm = ts(relevant_ind)-reference_start_time(i);
            temp_vel = vel_touse(relevant_ind);
            this_world = mod(relevant_world_type(i),4);
            if this_world ==0
                this_world = 4;
            end
            save_tm_pts{this_world} = [save_tm_pts{this_world} temp_tm];
            save_vel{this_world} = [save_vel{this_world} temp_vel];
            plot(temp_tm,temp_vel,Color=colors_to_use(this_world,:));
        end
        xline(ramp_up_dur,'--')
        xline(ramp_up_dur+ramp_sus_dur,'--')
        xlabel("Time (s)")
        ylabel("Velocity (cm/s)")
        xlim([0 opto_dur])
        title([opto_names{is_opto+1},': ', title_options{vel_ind},' Velocity'])

        % save opto results for mean sem plotting
        if is_opto ==0
            normal_tm_pts = save_tm_pts;
            normal_vel = save_vel;
        else
            opto_tm_pts = save_tm_pts;
            opto_vel = save_vel;
        end
    end

    % if we want to plotMeanSEM we need to bin by time
    % and separate this by world types!!!!!
    ax_tm(vel_ind+4) = subplot(3,n_col,vel_ind+n_col*2);hold on
    all_world_type_no_checker = all_world_type;
    all_world_type_no_checker(all_world_type_no_checker>4) = all_world_type_no_checker(all_world_type_no_checker>4)-4;
    
    for this_world = unique(all_world_type_no_checker) 
        [mean_binned_a,sem_binned_a] = binByTimeOrPos(opto_tm_pts{this_world},opto_vel{this_world},tm_bin_edges);
        plotMeanSEM(tm_bin_ctrs,mean_binned_a,sem_binned_a,opto_colors(this_world,:))
        [mean_binned_a,sem_binned_a] = binByTimeOrPos(normal_tm_pts{this_world},normal_vel{this_world},tm_bin_edges);
        plotMeanSEM(tm_bin_ctrs,mean_binned_a,sem_binned_a,normal_colors(this_world,:))
    end
    xline(ramp_up_dur,'--')
    xline(ramp_up_dur+ramp_sus_dur,'--')
    xlabel("Time (s)")
    ylabel("Velocity (cm/s)")
    xlim([0 opto_dur])
    title([title_options{vel_ind},' Velocity Mean ',char(177),' SEM'])

    % plot velocity by forward position to see if effects carry
    % over (if is_maze_opto is true)
    if plot_maze_pos
        for is_opto = 0:1
            save_pos = {};
            save_pos_vel = {};
            for j = 1:4
                save_pos{j} = [];
                save_pos_vel{j} = [];
            end

            if is_opto == 0
                trials_to_plot = normal_trials;
                relevant_world_type = normal_world_type;
                colors_to_use = normal_colors;
            else
                trials_to_plot = opto_end_trials;
                relevant_world_type = opto_world_type;
                colors_to_use = opto_colors;
            end

            % plotting trial by trial
            ax_pos(vel_ind+2*is_opto) = subplot(3,n_col,vel_ind+2+n_col*is_opto);hold on
            for i = 1:length(trials_to_plot)
                relevant_ind = iter_trial==trials_to_plot(i);
                temp_pos = forw_pos(relevant_ind);
                temp_vel = vel_touse(relevant_ind);
                this_world = mod(relevant_world_type(i),4);
                if this_world ==0
                    this_world = 4;
                end
                save_pos{this_world} = [save_pos{this_world} temp_pos];
                save_pos_vel{this_world} = [save_pos_vel{this_world} temp_vel];
                plot(temp_pos,temp_vel,Color=colors_to_use(this_world,:));
            end
            xline(150,'--')
            xlabel("Forwad Position (cm)")
            ylabel("Velocity (cm/s)")
            xlim([start_pos end_pos])
            title([opto_names{is_opto+1},': ', title_options{vel_ind},' Velocity'])
            % save opto results for mean sem plotting
            if is_opto ==0
                normal_pos = save_pos;
                normal_pos_vel = save_pos_vel;
            else
                opto_pos = save_pos;
                opto_pos_vel = save_pos_vel;
            end
        end

        % if we want to plotMeanSEM we need to bin by time
        % and separate this by world types!!!!!
        ax_pos(vel_ind+4) = subplot(3,n_col,vel_ind+2+n_col*2);hold on
        for this_world = unique(all_world_type_no_checker)
            [mean_binned_a,sem_binned_a] = binByTimeOrPos(opto_pos{this_world},opto_pos_vel{this_world},pos_bin_edges);
            plotMeanSEM(pos_bin_ctrs,mean_binned_a,sem_binned_a,opto_colors(this_world,:))
            [mean_binned_a,sem_binned_a] = binByTimeOrPos(normal_pos{this_world},normal_pos_vel{this_world},pos_bin_edges);
            plotMeanSEM(pos_bin_ctrs,mean_binned_a,sem_binned_a,normal_colors(this_world,:))
        end
        xline(150,'--')
        xlabel("Forwad Position (cm)")
        ylabel("Velocity (cm/s)")
        xlim([start_pos end_pos])
        title([title_options{vel_ind},' Velocity Mean ',char(177),' SEM'])

    end
    linkaxes(ax_tm,'y');
    if is_maze_opto
        linkaxes(ax_pos,'y')
    end
end

% also want to plot bar graph of correctness with opto on and off
subplot(3,n_col,n_col)
bar_x = categorical({'Normal','Opto'});
% we always care about the correctness for the trial in which opto ends
corr_normal_opto =  [mean(trial_rewarded(normal_trials)) mean(trial_rewarded(opto_end_trials))];
bar(bar_x,corr_normal_opto);
box off
ylabel("Frac correct")

subplot(3,n_col,n_col*2) % color legend
hold on
world_labels = {};
uniq_worlds = unique(all_world_type_no_checker);
for j = 1:length(uniq_worlds)
    this_world = uniq_worlds(j);
    world_labels = [world_labels ['opto ',world_names{this_world}] ['norm ',world_names{this_world}]];
    patch([0 1 1 0], [j j j-.5 j-.5], opto_colors(this_world,:),'EdgeColor','none');
    patch([0 1 1 0], [j j j+.5 j+.5], normal_colors(this_world,:),'EdgeColor','none');
end
legend(world_labels,'FontSize',15,'Location','north');
ylim([-10 0])
yticks([])
xticks([])
set(gca,'visible','off')


end