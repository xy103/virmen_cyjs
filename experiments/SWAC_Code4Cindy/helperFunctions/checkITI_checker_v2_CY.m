function vr = checkITI_checker_v2_CY(vr)
% CY modified 4/26/2022 to allow checkers only n trials after switch

% check whether ITI has elapsed and if so, start a new trial

if vr.inITI == 1
    
    vr.itiTime = toc(vr.itiStartTime);
    
    if vr.itiTime > vr.itiDur
        
        % increase numtrials counter
        vr.numTrials = vr.numTrials + 1;
        % update live plots
        % vr = updateLivePlots(vr);
        if contains(vr.isEphys,'n')
            vr = plot_lick(vr);
        end
        %save trial data
        vr = saveTrialData(vr);
        
        % set up next trial, check whether switch should be introduced
        vr = dynamicSwitching_new_CA(vr);
        
        % update block
        vr.blockWorlds = vr.contingentBlocks(vr.switchBlock,:);

        % CY added to compare number of elapsed trials since last sw and
        % only allow checker after a certain number of trials
        if isempty(vr.Switches) == 1
            temp_sw_trials = 0;
        else
            temp_sw_trials = vr.Switches; 
        end
        numTrialSinceSW = (vr.numTrials) - temp_sw_trials(end);

        if numTrialSinceSW > vr.allowCheckerAfterNTrials
            % change to noChecker maze probabilistically
            rand_checker = rand;
            if rand_checker > vr.fractionNoChecker % give checker trial
                vr.Checker_trial = [vr.Checker_trial 1];
                vr.blockWorlds = vr.blockWorlds + 4;
            else
                vr.Checker_trial = [vr.Checker_trial 0];
            end
        else % checker forbidden
            vr.Checker_trial = [vr.Checker_trial 0];
        end

        vr = chooseNextWorld_CA(vr);
        vr.inITI = 0;
        
        vr.position = vr.worlds{vr.currentWorld}.startLocation;
        vr.worlds{vr.currentWorld}.surface.visible(:) = 1;
        vr.worlds{vr.currentWorld}.backgroundColor = [vr.backgroundR_val vr.backgroundG_val vr.backgroundB_val];
        vr.dp = 0;
        vr.inRewardZone = 0;
        vr.trialTimer = tic;
        vr.trialStartTime = rem(now,1);
        
        vr = printText2CommandLine(vr);
    end
end

end