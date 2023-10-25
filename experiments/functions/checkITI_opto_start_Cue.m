function vr = checkITI_opto_start_Cue(vr)

if vr.inITI == 1 
    
    vr.itiTime = toc(vr.itiStartTime);
    
    if vr.itiTime <vr.itiDur  
        % need to check how much time remains in ITI
        vr.itiCountdown = vr.itiDur - vr.itiTime; 
        
        % ITI is not up yet and we have just past the point of opto initation
        % for the next trial without opto being turned on
        if (vr.itiCountdown <= vr.optoTriggerPoint) && (vr.optoOn == 0) && vr.nextTrialOpto
            vr.optoOn = 1; % turn opto on
            vr.optoStartTime = tic; % start time of current opto 
            vr.optoOnSec = toc(vr.optoStartTime); % time in seconds since the current opto stimulation onset
%             vr.optoOutVoltage = 0; % set output voltage to 0 to start
            vr.nDeliveredOpto = vr.nDeliveredOpto+1;
            vr.optoStartIter = [vr.optoStartIter vr.totIterations]; % record which iter had opto starting
            vr = checkForOptoDelivery_Cue(vr); % call once to start outputting
            % print out update
            fprintf("\n**Start ramping up for light inhibition #%i\t",vr.nDeliveredOpto)
        end
    end
end