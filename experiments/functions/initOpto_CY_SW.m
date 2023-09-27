function vr = initOpto_CY_SW(vr)
% initialization function for opto during switching task

vr.optoOn = 0; % initialize opto indicator to be 0 (change to 1 when opto is on) 
vr.optoOnSec = 0; % keep at 0 at init
vr.optoOutVoltage = 0; 

vr.optoMaxVoltage = eval(vr.exper.variables.optoMaxVoltage); % max voltage value
vr.optoThreshold = eval(vr.exper.variables.optoThreshold); % probability/threshold for opto stimulation

vr.optoRampUpDur = eval(vr.exper.variables.optoRampUpDur); % ramp on duration in sec 
vr.optoRampDownDur = eval(vr.exper.variables.optoRampDownDur); % ramp off duration in sec 
vr.optoLightDur = eval(vr.exper.variables.optoLightDur); % sustained light duration in sec 

vr.nDeliveredOpto = 0; % how many have already been delivered

fprintf("Max voltage is %.2f mV, with %.2f s ramp up, %.2f s sustained, and %.2f s ramp down\n",vr.optoMaxVoltage,vr.optoRampUpDur,vr.optoLightDur,vr.optoRampDownDur)
end