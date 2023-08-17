function vr = checkITI_opto_CYJB(vr)

% check whether ITI has elapsed and if so, start a new trial

if vr.inITI == 1
    
    vr.itiTime = toc(vr.itiStartTime);

    % start opto ramp up based on variable trigger point
    if (vr.trialOptoVar <= vr.optoThreshold) && ((vr.itiTime > vr.optoTriggerPoint) && vr.optoOn == 0)
        vr.optoOn = 1; 
        vr.optoOnSec = 0; % time in seconds since the current opto stimulation onset
        vr.optoOutVoltage = 0; % set output voltage to 0 to start
        vr.nDeliveredOpto = vr.nDeliveredOpto+1;
        vr.currentMaxVoltage = vr.optoMaxVoltage; % vr.allOptoVoltage(vr.nDeliveredOpto);
        % print out update
        % fprintf('\n Time elapsed: %s \t',datestr(now-vr.timeStarted, 'HH:MM:SS')); % print the time elapsed 
        fprintf(" Light inhibition #%i,\t max voltage %.1f mV\t\n",vr.nDeliveredOpto,vr.currentMaxVoltage)
    end

    % if opto has initiated and we are still in ITI, proceed with opto
    if vr.optoOn && vr.itiTime <= vr.itiDur
        vr.optoOnSec = vr.optoOnSec + vr.dt; % update how much time opto has been on
        % determine output voltage based on how much time has eplased since
        % light was turned on
        if vr.optoOnSec < vr.optoRampDur % ramp up
            vr.optoOutVoltage = (1/vr.optoRampDur * vr.optoOnSec)*vr.currentMaxVoltage;
        elseif (vr.optoOnSec <= vr.optoRampDur+vr.optoLightDur) % sustained period
            vr.optoOutVoltage = vr.currentMaxVoltage;
        elseif (vr.optoOnSec <= vr.optoRampDur*2+vr.optoLightDur)% ramp down
            vr.optoOutVoltage = (1-1/vr.optoRampDur * (vr.optoOnSec-vr.optoRampDur-vr.optoLightDur))*vr.currentMaxVoltage;
        elseif vr.OptoOnSec > ((vr.optoRampDur * 2) + vr.optoLightDur)
            fprintf(" Light off after %.1f s\n",vr.optoOnSec)
            vr.optoOutVoltage = 0;
            vr.optoOn = 0; % turn opto off
            vr.optoOnSec = 0; % default to 0 since nan gives issue with comparison
            vr.optoElapsed = 0;
        end
        outputSingleScan(vr.opto_ao,vr.optoOutVoltage)
    end

    % if opto is running and the ITI ends, cut it off and save optoElapsed,
    % then feed to checkForOptoDelivery_SW for continuation of opto during
    % trial
    if vr.optoOn && vr.itiTime > vr.itiDur
        vr.optoElapsed = vr.optoOnSec;
    end

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
        % change to noChecker maze probabilistically
        rand_checker = rand;
        if rand_checker > vr.fractionNoChecker % give checker trial
            vr.Checker_trial = [vr.Checker_trial 1];
            vr.blockWorlds = vr.blockWorlds + 4;
        else
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