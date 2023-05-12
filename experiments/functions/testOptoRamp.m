% function to test analog output for GtACR2 silencing
% potential issue with ramp signal getting stuck 

function testOptoRamp(dq, ramp_dur,light_dur, light_voltage)
%% 
% dq is the daq device, assuming already initialized session and output channel
% use ramp_dur (s), light_dur (s), light_voltage (V) to generate a symmetric linear
% ramp up to and down from light_voltage

sr = dq.Rate; 
ramp_samp = round(sr*ramp_dur);
light_samp = round(sr*light_dur);

sig = [linspace(0,light_voltage,ramp_samp) repmat(light_voltage,1,light_samp) linspace(light_voltage,0,ramp_samp)]';

queueOutputData(dq,sig);
startBackground(dq)

end
