function vr = init_switching_task(vr)
% Code to initialize virmen object for switching task 
% JS 7/15/21
    vr.ops = getRigInfo();
    vr.taskName = 'sw'; % CY added 2/9/2022 to call on ao of pxi for switching only

    % only check ephys status for CY ephys rig
    if contains(vr.ops.rigName,'CYJS_EphysRig')
        isEphys = inputdlg('Is this ephys recording(y/n)? ');
        if contains(isEphys,'y')
            fprintf('Disabling plots for ephys recording\n');
        else
            fprintf('Initializing lick plots\n');
        end
        vr.isEphys = isEphys;
    else
        vr.isEphys = 'n';
    end
    
    % evaluate background rbg values
    vr.backgroundR_val = eval(vr.exper.variables.backgroundR_val);
    vr.backgroundG_val = eval(vr.exper.variables.backgroundG_val);
    vr.backgroundB_val = eval(vr.exper.variables.backgroundB_val);
    
    vr.world_names = cellfun(@(x) x.name,vr.exper.worlds,'UniformOutput',false); 

    % evaluate maze geometry parameters  //////////////
    vr.floorLength = eval(vr.exper.variables.floorLength);
    vr.funnelLength = eval(vr.exper.variables.funnelLength);
    vr.floorWidth = eval(vr.exper.variables.floorWidth);
    vr.funnelWidth = eval(vr.exper.variables.funnelWidth);
    vr.hideCuePast = vr.floorLength + vr.funnelLength + 5;
    vr.rewardLength = 5 + vr.floorLength + vr.funnelLength;
    % Identify indices for cue target walls (for hiding)
    vr = getHidingTargetVertices_cyjs(vr); 

    % evaluate and set parameters for movement and friction
    vr.friction = 0; % might want to make this nonzero for straight running training

    % evaluate timing parameters
    vr.feedbackDelay = eval(vr.exper.variables.feedbackDelay);
    vr.rewardDelay = eval(vr.exper.variables.rewardDelay);
    vr.itiCorrect = eval(vr.exper.variables.itiCorrect); % 
    vr.itiMissBase = eval(vr.exper.variables.itiMissBase); 

    % enable trial selection counteracting a choice bias
    vr.ContraBias = eval(vr.exper.variables.contraBias); % 0 if no bias counteracting enforced, 1 if enforced 
    vr.inds2check = eval(vr.exper.variables.inds2check); % choices to check for bias correction
    vr.pastChoices = []; % vector that will be a list of choices made

    % eval params for switching task
    vr.nWorlds = length(vr.worlds); 
    vr.contingentBlocks = [1 4; 2 3]; % JS

    % Switch parameters!
    % introduce switches dynamically depending on performance of mouse:
    % set a minimum block size, window size, and fraction correct for window to
    % introduce a switch
    vr.minBlockSize = eval(vr.exper.variables.minBlockSize_Switch);
    vr.minFrac_Corr_4Switch = eval(vr.exper.variables.fractionCorrect_Switch);
    vr.minWindow_4Switch = eval(vr.exper.variables.minWindow_Switch);
    vr.Rewards = [];
    vr.Switches = [];
    vr.Checker_trial = []; % visually guided trial? 
    vr.pastCorrect = []; % what was the correct choice?
    initBlock = eval(vr.exper.variables.initBlock); % sets the initial block: alternate daily
    vr.switchBlock = initBlock; 

    % Choose the first world
    worldChoice = randi(size(vr.contingentBlocks,2));
    vr.currentWorld = vr.contingentBlocks(initBlock,worldChoice); % CA modified [JS assumes to allow us to choose init block]

    % choose a non-checker trial probabilistically
    vr.fractionNoChecker = eval(vr.exper.variables.fractionNoChecker);

    rand_checker = rand;
    if rand_checker > vr.fractionNoChecker
        vr.Checker_trial = [vr.Checker_trial 1];
        vr.currentWorld = vr.currentWorld + 4;
    else 
        vr.Checker_trial = [vr.Checker_trial 0];
    end

    % Gain (JS from initTMaze)
    vr.yawGain = 1;
    vr.pitchGain = 1; %07/26 CY fixed from 20 to 1
    vr.targetRevealed = false; 
    
    % initialize a bunch of counters (inITI, totIterations,
    % trialIterations etc.)
    vr = initCounters(vr);
end

