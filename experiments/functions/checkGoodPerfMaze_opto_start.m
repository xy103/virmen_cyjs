function vr = checkGoodPerfMaze_opto_start(vr)
% a switch must have happened, and we're now at the good performance period
% indicated by more than .9 correct in the last 10 trials

if ~isempty(vr.Switches) % a switch has occured
    window2check = (vr.numTrials - vr.goodPerfWindowBeforeOpto) : vr.numTrials;
    if sum(vr.Rewards(window2check))/numel(window2check) >= vr.goodPerfFracCorrect  % condition 2)
        if (vr.Rewards(vr.numTrials) == 1) && ~vr.numTrialcurrentBlockOpto % condition 3)
            vr.numTrialcurrentBlockOpto = 1;
        end
    end
end

if vr.numTrialcurrentBlockOpto > 0
    % only consider starting if within nTrialsContinuousOpto post switching
    if vr.numTrialcurrentBlockOpto <= vr.nTrialsContinuousOpto
        % opto is not on yet but we have started a reward delay and have not received visual feedback
        if  (vr.inRewardZone == 1) && ~vr.optoOn && (vr.inITI~=1) % waiting for feedback but not in iti yet
            vr.optoOn = 1; % turn opto on
            vr.optoStartTime = tic; % start time of current opto 
            vr.optoStartIter = [vr.optoStartIter vr.totIterations]; % record which iter had opto starting
            vr.nDeliveredOpto = vr.nDeliveredOpto+1;
            vr.numTrialcurrentBlockOpto = vr.numTrialcurrentBlockOpto +1;
            vr = checkForOptoDelivery_SW(vr); % call once to start outputting
            % print out update
            fprintf("**Good performance ITI opto: wait for feedback & ramping up for light inhibition #%i\n",vr.nDeliveredOpto)
        end
    end
end
