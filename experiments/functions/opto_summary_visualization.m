function opto_summary_visualization(sessionData,parameters,optoData)
%% plot settings
% mazeOpto: light starts ramping in the previous trial's ITI and
% persists during current trial's maze (time and position both relevant)
% should separate by cue and rule type
% itiOpto: light starts ramping in the current trial's waiting period
% for feedback and continues into ITI (only time relevant)
% should separate by turn type

is_maze_opto = contains(parameters.name,'maze'); % inidicator to set up plots

% set up colors and account for cue and turn pairings
[paired_map] = cbrewer('qual', 'Paired', 8); % 4 pairs of colors
opto_colors = paired_map(1:2:end,:);
normal_colors = paired_map(2:2:end,:); % lighter colors of matched trial types
% 1 - WR, 2 - WL, 3 - BR, 4 - BL
% 5 - cWR, 6 - cWL, 7 - cBR, 8 - cBL
world_names = {'WR', 'WL','BR','BL'};

% Collect useful data together
maze_len = str2num(parameters.variables.floorLength) + str2num(parameters.variables.funnelLength);
rewardLength = 5 + maze_len;
ramp_up_dur = str2num(parameters.variables.optoRampUpDur);
ramp_down_dur = str2num(parameters.variables.optoRampDownDur);
ramp_sus_dur = str2num(parameters.variables.optoLightDur);
opto_dur = ramp_up_dur + ramp_down_dur + ramp_sus_dur;

ts = cumsum(sessionData(10,:)); % timestamp
iter_trial = sessionData(end,:);
% opto start and end should be the same if ITI opto
opto_start_trials = sessionData(end,optoData.optoStartIter);
opto_end_trials = sessionData(end,optoData.optoEndIter); % opto always end on the trial we want to perturb
opto_start_tm = ts(optoData.optoStartIter);
opto_end_tm = ts(optoData.optoEndIter);
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
    if is_maze_opto
        tm_from_trial_end = trial_tm(end)-trial_tm;
        normal_trials_comp_start_tm(i) = trial_tm(find(tm_from_trial_end<=ramp_up_dur,1));
    else % light starts while waiting for feedback and reward
        normal_trials_comp_start_tm(i) = trial_tm(find(sessionData(6,iter_trial==normal_trials(i))>=rewardLength,1));
    end
end

lat_vel = sessionData(2,:);
forw_vel = sessionData(3,:);
tm_bin_size = .05;
tm_bin_edges = -tm_bin_size/2:tm_bin_size:opto_dur+tm_bin_size/2;
tm_bin_ctrs = tm_bin_edges(1:end-1)+tm_bin_size/2;

%%
% we already know when opto starts and ends (in iters) from optoData
title_options = {'Lateral','Forward'};

f = figure('Position', [300 200 1000 700]);
if is_maze_opto
    sgtitle('Maze Inhibition')
else
    sgtitle('ITI Inhibition')
end
ax = gobjects(6,1);
% we want to plot forward and lateral velocity with opto on and off (x axis is time)
for vel_ind = 1:2
    if vel_ind ==1
        vel_touse = lat_vel;
    else
        vel_touse = forw_vel;
    end

    ax(vel_ind) = subplot(3,3,vel_ind);hold on
    % plotting trial by trial
    opto_tm_pts = {};
    opto_vel = {};
    normal_tm_pts = {};
    normal_vel = {};
    for j = 1:4
        opto_tm_pts{j} = [];
        opto_vel{j} = [];
        normal_tm_pts{j} = [];
        normal_vel{j} = [];
    end
    for i = 1:length(optoData.optoStartIter)
        relevant_ind = optoData.optoStartIter(i):optoData.optoEndIter(i);
        temp_tm = ts(relevant_ind)-opto_start_tm(i);
        temp_vel = vel_touse(relevant_ind);
        this_world = mod(opto_world_type(i),4);
        opto_tm_pts{this_world} = [opto_tm_pts{this_world} temp_tm];
        opto_vel{this_world} = [opto_vel{this_world} temp_vel];
        plot(temp_tm,temp_vel,Color=opto_colors(this_world,:));
    end
    xline(ramp_up_dur,'--')
    xline(ramp_up_dur+ramp_sus_dur,'--')
    xlabel("Time (s)")
    ylabel("Velocity (cm/s)")
    xlim([0 opto_dur])
    title(['Opto: ', title_options{vel_ind},' Velocity'])

    % plot corresponding times when opto is off
    ax(vel_ind+2) = subplot(3,3,vel_ind+3);hold on
    for i = 1:length(normal_trials)
        relevant_ind = ts>=normal_trials_comp_start_tm(i)&(ts<normal_trials_comp_start_tm(i)+opto_dur);
        temp_tm = ts(relevant_ind)-normal_trials_comp_start_tm(i);
        temp_vel = vel_touse(relevant_ind);
        this_world = mod(normal_world_type(i),4);
        normal_tm_pts{this_world} = [normal_tm_pts{this_world} temp_tm];
        normal_vel{this_world} = [normal_vel{this_world} temp_vel];
        plot(temp_tm,temp_vel,Color=normal_colors(normal_world_type(i),:));
    end
    xline(ramp_up_dur,'--')
    xline(ramp_up_dur+ramp_sus_dur,'--')
    xlabel("Time (s)")
    ylabel("Velocity (cm/s)")
    xlim([0 opto_dur])
    title(['Normal: ',title_options{vel_ind},' Velocity'])

    % if we want to plotMeanSEM we need to bin by time
    % and separate this by world types!!!!!
    ax(vel_ind+4) = subplot(3,3,vel_ind+6);hold on
    for this_world = unique(all_world_type)
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
end
linkaxes(ax,'y');

% also want to plot bar graph of correctness with opto on and off
subplot(3,3,3)
bar_x = categorical({'Normal','Opto'});
% we always care about the correctness for the trial in which opto ends
corr_normal_opto =  [mean(trial_rewarded(normal_trials)) mean(trial_rewarded(opto_end_trials))];
bar(bar_x,corr_normal_opto);
box off
ylabel("Frac correct")

subplot(3,3,9) % color legend
hold on
world_labels = {};
uniq_worlds = unique(all_world_type);
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

% Maybe: plot velocity by position to see if effects carry
% over (if is_maze_opto is true)


end