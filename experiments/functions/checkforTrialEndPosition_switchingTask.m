 function vr = checkforTrialEndPosition_switchingTask(vr)
    % Check if we've reached the end of a trial in SYT switching task
    % JS 7/15/21
    % Note vr.rewardLength = 5 + floorLength + funnelLength; from init_switching_task
    if vr.inITI == 0 && (vr.position(2) >= vr.rewardLength)
        % Disable movement
        vr.dp = 0*vr.dp;
        % Enforce Reward Delay
        if ~vr.inRewardZone
            vr.rewStartTime = tic;
            vr.inRewardZone = 1;
            vr.hasFeedback = 0;
            % make position consistent across trials
            vr.position(1:2) = [sign(vr.position(1))*vr.funnelWidth/4, vr.rewardLength];
        end
        
        vr.rewDelayTime = toc(vr.rewStartTime); % = how long we've been in delay 
        if ~vr.hasFeedback && (vr.rewDelayTime > vr.feedbackDelay)
            vr.hasFeedback = 1;
            vr.position(2) = vr.rewardLength + 1e-3; % unhide the checkers
            vr.behaviorData(8,vr.trialIterations) = -2; % checker unhided
            vr.behaviorData(9,vr.trialIterations) = 0;
            
        elseif vr.rewDelayTime > vr.rewardDelay % unrewarded trials
            % keep track of choices in past to identify bias and add more
            % worlds with opposite choice to make
            if vr.position(1) > 0
                choiceMade = "R";
            else
                choiceMade = "L";
            end
            vr.pastChoices = [vr.pastChoices choiceMade];

            % Check reward condition
            rightWorld = ismember(vr.currentWorld, [1 3 5 7]); % right is correct in odd worlds
            if rightWorld 
               vr.pastCorrect = [vr.pastCorrect "R"];
            else
                vr.pastCorrect = [vr.pastCorrect "L"]; 
            end
            rightArm = vr.position(1) > 0;
            if ~abs(rightWorld-rightArm) % rightWorld-rightArm == 0
                %deliver reward if appropriate
                vr.behaviorData(9,vr.trialIterations) = 1;
                vr.numRewards = vr.numRewards + 1;
                vr = giveReward(vr,1);
                vr.Rewards = [vr.Rewards 1]; % append the vector containing binary reward info per trial
                vr.itiDur = vr.itiCorrect;
                %vr.wrongStreak = 0; % not used by CA
            else
                % update wrongStreak counter if incorrect
                vr.behaviorData(9,vr.trialIterations) = 0;
                %vr.itiMiss = vr.itiMissBase + vr.penaltyITI*vr.wrongStreak;
                vr.itiMiss = vr.itiMissBase; % CA
                vr.itiDur = vr.itiMiss;
                %vr.wrongStreak = vr.wrongStreak + 1; % not used by CA
                vr.Rewards = [vr.Rewards 0]; % append the vector containing binary reward info per trial
                
            end

            % start the ITI
            vr = startITI_CA_Rig2(vr); 
            vr = plot_lick(vr); 
        else % reward delay (prior to delivery)
            vr.behaviorData(9,vr.trialIterations) = 0;
            vr.behaviorData(8,vr.trialIterations) = -1;
        end
    else
        vr.behaviorData(9,vr.trialIterations) = 0;
    end
end

