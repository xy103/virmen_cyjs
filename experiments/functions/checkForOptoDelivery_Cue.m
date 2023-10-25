function vr = checkForOptoDelivery_Cue(vr)
% deliver optogenetic stimulation based on time elpased in vr.optoOnSec and
% also maze position

if vr.optoOn % indicator for opto light
    vr.optoOnSec = toc(vr.optoStartTime);% update how much time opto has been on
    % determine output voltage based on how much time has eplased since
    % light was turned on

    if vr.optoOnSec <= vr.optoRampUpDur % ramp up
        vr.optoOutVoltage = (1/vr.optoRampUpDur * vr.optoOnSec)*vr.optoMaxVoltage;
    else % past ramp up time
        if vr.rampDownStartSec==0 % in maze, have not entered ramp down
            if (vr.position(2) < vr.floorLength)&&(vr.optoOnSec < vr.maxOptoTmBeforeRampDown)% sustained period
                vr.optoOutVoltage = vr.optoMaxVoltage;
            elseif vr.inITI==0 % position or time condition violated
                vr.rampDownStartSec = tic;
                if vr.position(2) > vr.floorLength
                    fprintf("**Ramping light down past stem after %.1f s\n",vr.optoOnSec)
                else
                     fprintf("**Ramping light down past max time after %.1f s\n",vr.optoOnSec)
                end
                vr.optoOutVoltage = (1-1/vr.optoRampDownDur * toc(vr.rampDownStartSec))*vr.optoMaxVoltage;
            end
        else % vr.rampDownStartSec>0 
            if toc(vr.rampDownStartSec)<vr.optoRampDownDur
                vr.optoOutVoltage = (1-1/vr.optoRampDownDur * toc(vr.rampDownStartSec))*vr.optoMaxVoltage;
            else %if (vr.rampDownStartSec>0) && (toc(vr.rampDownStartSec)>vr.optoRampDownDur)
                fprintf("**Light off after %.1f s\n",vr.optoOnSec)
                vr.optoOutVoltage = 0;
                vr.optoOn = 0; % turn opto off
                vr.optoOnSec = 0; % default to 0 since nan gives issue with comparison
                vr.rampDownStartSec = 0;
                vr.optoEndIter = [vr.optoEndIter vr.totIterations]; % collect iter when opto ends
            end
        end
    end
    outputSingleScan(vr.opto_ao,vr.optoOutVoltage)
end

% save output voltage in the 14th row
vr.behaviorData(14, vr.trialIterations) = vr.optoOutVoltage;
end


