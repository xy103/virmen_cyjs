function [vr] = checkforTrialEndPosition_linearTrack(vr)
% check for trial-terminating position and deliver reward
if vr.inITI == 0 && (vr.position(2) > vr.mazeLength + vr.cueLength - 3)
    % Disable movement
    vr.dp = 0*vr.dp;
    % Enforce Reward Delay
    if ~vr.inRewardZone
        vr.rewStartTime = tic;
        vr.inRewardZone = 1;
    end
    vr.rewDelayTime = toc(vr.rewStartTime);
    if vr.rewDelayTime>vr.rewardDelay
        vr = giveReward(vr,1); % JS uncommented
        vr.behaviorData(9,vr.trialIterations) = 1;
        vr.numRewards = vr.numRewards + 1;
        vr.itiDur = 3;
        vr = updateLivePlots(vr); 
        vr = endVRTrial(vr);
    else
        vr.behaviorData(9,vr.trialIterations) = 0;
        vr.behaviorData(8,vr.trialIterations) = -1;
    end
else
    vr.behaviorData(9,vr.trialIterations) = 0; 
end
end

