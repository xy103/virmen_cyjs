function vr = initOpto_CY_SW(vr)
% initialization function for 

vr.optoOn = 0; % initialize opto indicator to be 0 (change to 1 when opto is on) 
vr.optoOnSec = 0; % keep at 0 at init
vr.optoOutVoltage = 0; 
vr.trialOptoVar = 0; % initialize random variable for probabilistic opto delivery (updated at iteration 1 of each trial)

vr.optoMaxVoltage = eval(vr.exper.variables.optoMaxVoltage); % max voltage value
vr.optoThreshold = eval(vr.exper.variables.optoThreshold); % probability/threshold for opto stimulation

vr.optoRampUpDur = eval(vr.exper.variables.optoRampDur); % ramp on duration in sec 
vr.optoRampDownDur = eval(vr.exper.variables.optoRampDur); % ramp off duration in sec 
vr.optoLightDur = eval(vr.exper.variables.optoLightDur); % sustained light duration in sec 

vr.optoTriggerPoint = eval(vr.exper.variables.optoTriggerPoint); % time point after which opto signal can be delivered

vr.nDeliveredOpto = 0; % how many have already been delivered

fprintf("Max voltage is %.2f mV, with %.2f s ramp up, %.2f s sustained, and %.2f s ramp down ",vr.optoMaxVoltage,vr.optoRampUpDur,vr.optoLightDur,vr.optoRampDownDur)
end