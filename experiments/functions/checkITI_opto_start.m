function vr = checkITI_opto_start(vr)

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
            vr = checkForOptoDelivery_SW(vr); % call once to start outputting
            % print out update
            fprintf("**Start ramping up for light inhibition #%i,\t max voltage %.1f mV\t\n",vr.nDeliveredOpto,vr.optoMaxVoltage)
        end
    end
end