function vr = checkHighPerfMaze_opto_start(vr)
% (CY commented out 10/11/2024: a switch must have happened, and) we're now at the good performance period
% indicated by more than .9 correct in the last 10 trials

% (a switch has occured and we're at least 10 trials post it)
% CY 10/11/2024: removed sw requirement, just at least 10 trials post start
% of current rule block 
% if ~isempty(vr.Switches)&& (vr.numTrialSinceSW > vr.goodPerfWindowBeforeOpto) && ~vr.numTrialcurrentBlockOpto
if (vr.numTrialSinceSW > vr.goodPerfWindowBeforeOpto) && ~vr.numTrialcurrentBlockOpto
    trials_since_last_opto = vr.numTrials - vr.lastOptoTrial;
    if trials_since_last_opto > vr.minTrialsOptoWait
        window2check = (vr.numTrials - vr.goodPerfWindowBeforeOpto) : vr.numTrials;
        if sum(vr.Rewards(window2check))/numel(window2check) >= vr.goodPerfFracCorrect  % condition 2)
            if (vr.Rewards(vr.numTrials) == 1) % condition 3)
                vr.numTrialcurrentBlockOpto = 1;
            end
        end
    end
end

% only deliver opto if the rule has not changed since the last opto trial
if vr.numTrialcurrentBlockOpto > 0 
    % only consider starting if within nTrialsContinuousOpto post switching
    if vr.numTrialcurrentBlockOpto <= vr.nTrialsContinuousOpto
        if vr.numTrialSinceSW > vr.goodPerfWindowBeforeOpto
            % opto is not on yet but we have started a reward delay and have not received visual feedback
            if  (vr.inRewardZone == 1) && ~vr.optoOn && (vr.inITI~=1) % waiting for feedback but not in iti yet
                vr.optoOn = 1; % turn opto on
                vr.optoStartTime = tic; % start time of current opto 
                vr.optoStartIter = [vr.optoStartIter vr.totIterations]; % record which iter had opto starting
                vr.nDeliveredOpto = vr.nDeliveredOpto+1;
                vr.numTrialcurrentBlockOpto = vr.numTrialcurrentBlockOpto +1;
                vr.lastOptoTrial = vr.numTrials;
                vr = checkForOptoDelivery_SW(vr); % call once to start outputting
                % print out update
                fprintf("**Good performance ITI opto: wait for feedback & ramping up for light inhibition #%i\n",vr.nDeliveredOpto)
            end
        else
            fprintf("**Stopping opto trials early because of new switch\n")
            vr.numTrialcurrentBlockOpto = 0; % reset to 0
        end
    else % already past nTrialContinuousOpto
        vr.numTrialcurrentBlockOpto = 0; % reset to 0
    end
end
