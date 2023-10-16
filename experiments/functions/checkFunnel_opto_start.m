function vr = checkFunnel_opto_start(vr)

% mouse is in maze and just post trigger position on a opto trial
if vr.inITI == 0 && (vr.position(2) >= vr.optoTriggerPos) && vr.thisTrialOpto && (vr.optoOn == 0)
    vr.optoOn = 1; % turn opto on
    vr.optoStartTime = tic; % start time of current opto
    vr.optoOnSec = toc(vr.optoStartTime); % time in seconds since the current opto stimulation onset
    %             vr.optoOutVoltage = 0; % set output voltage to 0 to start
    vr.nDeliveredOpto = vr.nDeliveredOpto+1;
    vr.optoStartIter = [vr.optoStartIter vr.totIterations]; % record which iter had opto starting
    vr = checkForOptoDelivery_SW(vr); % call once to start outputting
    % print out update
    fprintf("\n**Start ramping up for light inhibition #%i\t",vr.nDeliveredOpto)
end