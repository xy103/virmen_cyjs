function vr = checkForOptoDelivery(vr)

% deliver optogenetic stimulation if current iter is one of the
% predetermined opto start iter

if ismember(vr.totIterations,vr.optoOnsetIter)
    % find out which voltage this iter should have
    vr.optoOn = 1; 
    vr.optoOnSec = 0; % time in seconds since the current opto stimulation onset
    vr.optoOutVoltage = 0; % set output voltage to 0 to start
    vr.nDeliveredOpto = vr.nDeliveredOpto+1;
    vr.currentMaxVoltage = vr.allOptoVoltage(vr.nDeliveredOpto);
    % print out update
    fprintf('\n Time elapsed: %s \t',datestr(now-vr.timeStarted, 'HH:MM:SS')); % print the time elapsed 
    fprintf(" Light inhibition No.%i, max voltage %.1f mV\t\n",vr.nDeliveredOpto,vr.currentMaxVoltage)
end

if vr.optoOn % indicator for opto light
    % determine output voltage based on how much time has eplased since
    % light was turned on
    vr.optoOnSec = vr.optoOnSec + vr.dt; % update how much time opto has been on
    if vr.optoOnsec < vr.optoRampDur % ramp up
        vr.optoOutVoltage = (1/vr.optoRampDur * vr.OptoOnSec)*vr.currentMaxVoltage;
    elseif (vr.optoOnsec <= vr.optoRampDur+vr.optoLightDur) % sustained period
        vr.optoOutVoltage = vr.currentMaxVoltage;
    elseif  (vr.optoOnsec <= vr.optoRampDur*2+vr.optoLightDur)% ramp down
        vr.optoOutVoltage = (1-1/vr.optoRampDur * (vr.OptoOnSec-vr.optoRampDur-vr.optoLightDur))*vr.currentMaxVoltage;
    else
        vr.optoOutVoltage = 0;
        vr.optoOn = 0; % turn opto off
        vr.optoOnSec = nan; 
    end
    outputSingleScan(vr.opto_ao,[vr.optoOutVoltage])
end


