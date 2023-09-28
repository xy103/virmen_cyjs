function vr = checkForOptoDelivery_SW(vr)
% deliver optogenetic stimulation based on time elpased in vr.optoOnSec

if vr.optoOn % indicator for opto light
    vr.optoOnSec = vr.optoOnSec + vr.dt; % update how much time opto has been on
    % determine output voltage based on how much time has eplased since
    % light was turned on
    if vr.optoOnSec < vr.optoRampUpDur % ramp up
        vr.optoOutVoltage = (1/vr.optoRampUpDur * vr.optoOnSec)*vr.optoMaxVoltage;
    elseif (vr.optoOnSec <= vr.optoRampUpDur+vr.optoLightDur) % sustained period
        vr.optoOutVoltage = vr.optoMaxVoltage;
    elseif (vr.optoOnSec <= vr.optoRampUpDur+vr.optoLightDur+vr.optoRampDownDur)% ramp down
        vr.optoOutVoltage = (1-1/vr.optoRampDownDur * (vr.optoOnSec-vr.optoRampUpDur-vr.optoLightDur))*vr.optoMaxVoltage;
    else
        fprintf(" Light off after %.1f s\n",vr.optoOnSec)
        vr.optoOutVoltage = 0;
        vr.optoOn = 0; % turn opto off
        vr.optoOnSec = 0; % default to 0 since nan gives issue with comparison
    end
    outputSingleScan(vr.opto_ao,vr.optoOutVoltage)
end

% save output voltage in the 14th row
vr.behaviorData(14, vr.trialIterations) = vr.optoOutVoltage;
end


