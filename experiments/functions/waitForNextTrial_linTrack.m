function vr = waitForNextTrial_linTrack(vr)

    if vr.inITI == 1
        %vr.worlds{vr.currentWorld}.backgroundColor = [0.5 0.5 0.5];
    %     vr.worlds{vr.currentWorld}.backgroundColor = [0 0 0]; % 170613: make ITI color same as grey background
        %vr.filtSpeed = .8 * vr.filtSpeed + .2 * norm(vr.velocity);
        vr.itiTime = toc(vr.itiStartTime);

        if vr.itiTime > vr.itiDur
            %save trial data
            vr = updateLivePlots(vr); % moved 7/12/21 from checkforTrialEndPosition
            vr = saveTrialData(vr); % moved 7/12/21 by JS from endVRTrial
            vr.numTrials = vr.numTrials + 1; % moved 7/12/21 by JS
            fprintf("%i trials complete \t %i rewards received \t %i rewards consumed \n",vr.numTrials,vr.numRewards,vr.numRewards_consumed)
            vr.inITI = 0;
            vr = chooseNextWorld(vr);
            vr.position = vr.worlds{vr.currentWorld}.startLocation;
            vr.worlds{vr.currentWorld}.surface.visible(:) = 1;
    %         vr.worlds{vr.currentWorld}.backgroundColor = [vr.backgroundR_val vr.backgroundG_val vr.backgroundB_val];
            vr.dp = 0;
            vr.inRewardZone = 0;
            vr.trialTimer = tic;
            vr.trialStartTime = rem(now,1);
            
            vr = printText2CommandLine_linearTrack(vr);
        end
    end
end