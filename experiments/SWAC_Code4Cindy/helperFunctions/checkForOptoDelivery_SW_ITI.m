function vr = checkForOptoDelivery_SW_ITI(vr)

% deliver optogenetic stimulation if trial opto parameter meets set
% threshold

if vr.trialIterations == 1
    vr.trialOptoVar = rand;
    vr.optoOnSec = vr.optoOnsec + vr.optoElapsed;
end

if vr.optoOn % indicator for opto light
    vr.optoOnSec = vr.optoOnSec + vr.dt; % update how much time opto has been on
    % determine output voltage based on how much time has eplased since
    % light was turned on
    if vr.optoOnSec < vr.optoRampDur % ramp up
        vr.optoOutVoltage = (1/vr.optoRampDur * vr.optoOnSec)*vr.currentMaxVoltage;
    elseif (vr.optoOnSec <= vr.optoRampDur+vr.optoLightDur) % sustained period
        vr.optoOutVoltage = vr.currentMaxVoltage;
    elseif (vr.optoOnSec <= vr.optoRampDur*2+vr.optoLightDur)% ramp down
        vr.optoOutVoltage = (1-1/vr.optoRampDur * (vr.optoOnSec-vr.optoRampDur-vr.optoLightDur))*vr.currentMaxVoltage;
    else
        fprintf(" Light off after %.1f s\n",vr.optoOnSec)
        vr.optoOutVoltage = 0;
        vr.optoOn = 0; % turn opto off
        vr.optoOnSec = 0; % default to 0 since nan gives issue with comparison
        vr.optoElapsed = 0;
    end
    outputSingleScan(vr.opto_ao,vr.optoOutVoltage)
end

% save output voltage in the 14th row
vr.behaviorData(14, vr.trialIterations) = vr.optoOutVoltage;
end


