function [vr] = giveReward(vr,nRew)
%giveReward Function which delivers rewards 
%(instantaneous pulses)
%   nRew - number of rewards to deliver
disp('Giving reward');
disp(['Reward number', num2str(vr.numRewards)]);

if vr.ops.useTeensyReward
    msgToSend = 3;
	vr.teensy.writeString(msgToSend);
else
    for i=1:nRew
        outputSingleScan(vr.ao,[5]);
        pause(vr.ops.rewardPulseDuration)
        outputSingleScan(vr.ao,[0]);
        pause(0.05)
    end
    vr.isReward = 1; %nRew
end