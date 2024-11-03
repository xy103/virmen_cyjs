function vr = checkMaze_opto_start_second_block(vr)
% current logic would always deliver inhibition for any trial post switch

if length(vr.Switches)==1 % exactly one switch has occured (hopefully this will also terminate opto if another switch occurs

    % only consider starting if within nTrialsContinuousOpto post switching
    if vr.numTrialSinceSW < vr.nTrialsContinuousOpto-1
        % opto is not on yet but we have started a reward delay and have not received visual feedback
        if  (vr.inRewardZone == 1) && ~vr.optoOn && (vr.inITI~=1) % waiting for feedback but not in iti yet
            vr.optoOn = 1; % turn opto on
            vr.optoStartTime = tic; % start time of current opto 
            vr.optoStartIter = [vr.optoStartIter vr.totIterations]; % record which iter had opto starting
            vr.nDeliveredOpto = vr.nDeliveredOpto+1;
            vr = checkForOptoDelivery_SW(vr); % call once to start outputting
            % print out update
            fprintf("**Wait for feedback & ramping up for light inhibition #%i\n",vr.nDeliveredOpto)
        end
    end
end
