function [vr] = checkforTrialEndPosition_linearTrackRectangleMiddle(vr)
% check for trial-terminating position and deliver reward
if vr.inITI == 0 && (vr.position(2) > vr.mazeLength + 5)
    
    % Disable movement
    vr.dp = 0*vr.dp;
    % Enforce Reward Delay
    if ~vr.inRewardZone
        vr.rewStartTime = tic;
        vr.inRewardZone = 1;
    end
    
    vr.rewDelayTime = toc(vr.rewStartTime);
    if vr.rewDelayTime > vr.rewardDelay
        
        % check if mouse is in reward zone mediolaterally
        if vr.frac_TargetWall < 1
            if vr.position(1) >= min(vr.ML_RewardZone) && vr.position(1) <= max(vr.ML_RewardZone)
                % give reward and store reward time
                vr.behaviorData(9,vr.trialIterations) = 1;
                vr.numRewards = vr.numRewards + 1;
                vr = giveReward(vr,1);
            else
                vr. behaviorData(9,vr.trialIterations) = 0;
            end
        end
        
        vr.itiDur = vr.itiCorrect;
        vr = updateLivePlots(vr); 
        vr = endVRTrial(vr);
<<<<<<< HEAD
        fprintf("%i trials complete \t %i rewards received \n",vr.numTrials,vr.numRewards)
=======
>>>>>>> parent of eae4a6b (some changes in printing)
    else
        vr.behaviorData(9,vr.trialIterations) = 0;
        vr.behaviorData(8,vr.trialIterations) = -1;
    end
else
    vr.behaviorData(9,vr.trialIterations) = 0;
end
end