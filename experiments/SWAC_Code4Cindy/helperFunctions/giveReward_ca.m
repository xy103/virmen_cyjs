function [vr] = giveReward_ca(vr,nRew) % changed by JS from giveReward
% giveReward Function which delivers rewards using the Master-8 system
%(instantaneous pulses)
%   nRew - number of rewards to deliver

sinDur = 0.033; % calibrated to give ca 4 ul (190826)

if ~vr.debugMode
    actualRate = vr.ao.Rate; %get sample rate
    pulselength=round(actualRate*sinDur*nRew); %find duration (rate*duration in seconds *numRew)
    disp(actualRate)
    disp(nRew)
    pulsedata=5.0*ones(pulselength,1); %5V amplitude
    pulsedata(pulselength)=0; %reset to 0V at last time point
    vr.ao.queueOutputData(pulsedata);
    startForeground(vr.ao);
    disp('reward delivered (this code)')
end

vr.isReward = nRew;

end