function [vr] = checkforTrialEndPosition_Tmaze(vr)
% check for trial-terminating position and deliver reward
%if vr.inITI == 0 && (vr.position(2) > vr.mazeLength +vr.bufferWidth + vr.cueLength) && (abs(vr.position(1))>4*vr.floorWidth)
if vr.inITI == 0 && (abs(vr.position(1))>vr.xRewardZoneThresh)
    % check if mouse is in reward zone mediolaterally, if 
    % Disable movement
    vr.dp = 0*vr.dp;
    % Enforce Reward Delay
    if ~vr.inRewardZone
        vr.rewStartTime = tic;
        vr.inRewardZone = 1;
    end
    vr.rewDelayTime = toc(vr.rewStartTime);    
    if vr.rewDelayTime > vr.rewardDelay
        vr.leftTrials(end+1) = vr.position(1)<0;
        correctLeft = mod(vr.currentWorld,2)==1 && vr.position(1)<0;
        correctRight = mod(vr.currentWorld,2)==0 && vr.position(1)>0;
        if correctLeft || correctRight
            vr.isCorrect = 1;
            vr = giveRecordProbReward(vr, vr.correctRewardProbability(vr.currentWorld));
            if correctLeft
                disp('Correct left turn trial');
            else
                disp('Correct right turn trial');
            end
            vr.itiDur = vr.itiCorrect;
        else
            vr.isCorrect = 0;
            vr = giveRecordProbReward(vr, vr.incorrectRewardProbability(vr.currentWorld));
            incorrectRight = mod(vr.currentWorld,2)==0;
            if incorrectRight
                disp('Incorrect right turn trial');
            else
                disp('Incorrect left turn trial');
            end
            vr.itiDur = vr.itiMiss;
        end
        vr = endVRTrial(vr);
    else
        vr.behaviorData(9,vr.trialIterations) = 0;
        vr.behaviorData(8,vr.trialIterations) = -1;
    end
else
    vr.behaviorData(9,vr.trialIterations) = 0; 
end
end

