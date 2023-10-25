function vr = checkForOptoDelivery_Cue(vr)
% deliver optogenetic stimulation based on time elpased in vr.optoOnSec and
% also maze position

if vr.optoOn % indicator for opto light
    vr.optoOnSec = toc(vr.optoStartTime);% update how much time opto has been on
    % determine output voltage based on how much time has eplased since
    % light was turned on
    if vr.optoOnSec < vr.optoRampUpDur % ramp up
        vr.optoOutVoltage = (1/vr.optoRampUpDur * vr.optoOnSec)*vr.optoMaxVoltage;
    elseif (vr.position(2) < vr.floorLength) && (vr.optoOnSec < vr.maxOptoTmBeforeRampDown)% sustained period, not exceed max time allowed for opto yet
        vr.optoOutVoltage = vr.optoMaxVoltage;
    elseif vr.rampDownStartSec==0 && ((vr.optoOnSec >= vr.maxOptoTmBeforeRampDown) || (vr.position(2) >= vr.floorLength)) % have not started ramp down and need to
        % start ramping down after max time has past or reached funnel
        vr.rampDownStartSec = tic; % keep track of when ramp down started 
        vr.optoOutVoltage = (1-1/vr.optoRampDownDur * toc(vr.rampDownStartSec))*vr.optoMaxVoltage;
    elseif vr.rampDownStartSec>0 && toc(vr.rampDownStartSec)<vr.optoRampDownDur % ramp down has already started and not ended yet
        vr.optoOutVoltage = (1-1/vr.optoRampDownDur * toc(vr.rampDownStartSec))*vr.optoMaxVoltage;
    else
        fprintf("**Light off after %.1f s\n",vr.optoOnSec)
        vr.optoOutVoltage = 0;
        vr.optoOn = 0; % turn opto off
        vr.optoOnSec = 0; % default to 0 since nan gives issue with comparison
        vr.rampDownStartSec = 0;
        vr.optoEndIter = [vr.optoEndIter vr.totIterations]; % collect iter when opto ends
    end
    outputSingleScan(vr.opto_ao,vr.optoOutVoltage)
end

% save output voltage in the 14th row
vr.behaviorData(14, vr.trialIterations) = vr.optoOutVoltage;
end


