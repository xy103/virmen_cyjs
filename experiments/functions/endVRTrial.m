function vr = endVRTrial(vr)
vr.itiStartTime = tic;
if vr.itiStartTime>.5
end
vr.worlds{vr.currentWorld}.surface.visible(:) = 0;
vr.inITI = 1;
% vr.numTrials = vr.numTrials + 1;
% %save trial data
% vr = saveTrialData(vr);
