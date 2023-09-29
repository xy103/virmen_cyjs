function vr = checkMaze_opto_start(vr)
% current logic would always deliver inhibition for any trial post switch

if ~isempty(vr.Switches) % a switch has occured

    % only consider starting if within nTrialsContinuousOpto post switching
    if vr.numTrialSinceSW < vr.nTrialsContinuousOpto 
        % opto is not on yet but we have started a reward delay and have not received visual feedback
        if  (vr.inRewardZone == 1) && (vr.optoOn == 0)
            vr.optoOn = 1; % turn opto on
            vr.optoStartTime = tic; % start time of current opto 
%             vr.optoOnSec = toc(vr.optoStartTime); % time in seconds since the current opto stimulation onset
            vr.nDeliveredOpto = vr.nDeliveredOpto+1;
            vr = checkForOptoDelivery_SW(vr); % call once to start outputting
            % print out update
            fprintf("**Wait for feedback & ramping up for light inhibition #%i\n",vr.nDeliveredOpto)
        end
    end
end
