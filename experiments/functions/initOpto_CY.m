function vr = initOpto_CY(vr)

vr.optoOn = 0; % initialize opto indicator to be 0 (change to 1 when opto is on) 
vr.optoOnSec = 0; % keep at 0 at init
vr.optoOutVoltage = 0; 

vr.optoMaxVoltage = eval(vr.exper.variables.optoMaxVoltage); % max voltage value
vr.optoMinVoltage = eval(vr.exper.variables.optoMinVoltage); % min voltage value
vr.optoVoltageIncrement = eval(vr.exper.variables.optoVoltageIncrement); % increment value
vr.optoRampDur = eval(vr.exper.variables.optoRampDur); % ramp on and off duration in sec 
vr.optoLightDur = eval(vr.exper.variables.optoLightDur); % sustained light duration in sec 
vr.optoRepeat = eval(vr.exper.variables.optoRepeat); % how many repetition per light level
vr.minIterBetweenOpto = eval(vr.exper.variables.minIterBetweenOpto); % how many iteration to wait until giving next opto
vr.maxIterBetweenOpto = eval(vr.exper.variables.maxIterBetweenOpto); % how many iteration to wait until giving next opto

% need to determine based on opto parameters how many runs of opto
% stimulation to give 
vr.allOptoVoltage = reshape(repmat(vr.optoMinVoltage:vr.optoVoltageIncrement:vr.optoMaxVoltage,vr.optoRepeat,1),[],1);
vr.totOpto = length(vr.allOptoVoltage); % total number of opto stimulation
vr.nDeliveredOpto = 0; % how many have already been delivered
% semi-randomly determine interval in iters between optogenetic stimulation
vr.optoOnsetIter = cumsum(randi([vr.minIterBetweenOpto vr.maxIterBetweenOpto],[vr.totOpto 1]));

fprintf("%i inhibitions scheduled, rangeing from %.2f to %.2f mV in %.2f mV increment \t\n",vr.totOpto,vr.optoMinVoltage,vr.optoMaxVoltage,vr.optoVoltageIncrement)
fprintf("First inhibition is iter %i\n",vr.optoOnsetIter(1));

