function vr = collectBehaviorIter_Opto(vr, varargin)
% collect behavior in dark world and also optogenetics info
global daqData;
lickInfo = daqData(4);

thisIter(1) = vr.currentWorld;
thisIter(2:4) = vr.velocity([1,2,4]); % vr.velocity(3) is dz/dt
thisIter(5:7) = vr.position([1,2,4]); % vr.position(3) is elevation

thisIter(8) = vr.inITI;
% 9 is reserved for the reward, not collected within this function
thisIter(10) = vr.dt;

thisIter(7) = lickInfo; % store signal from lick detector (ca 0 for no contact, ca 5 for contact)

vr.trialIterations = vr.trialIterations + 1;
vr.behaviorData([1:8,10],vr.trialIterations) = thisIter([1:8,10])';

vr.behaviorData(11:13, vr.trialIterations) = daqData(1:3); % record raw ball signal as well

vr.behaviorData(14, vr.trialIterations) = opto_voltage; % record a01 opto_voltage output
