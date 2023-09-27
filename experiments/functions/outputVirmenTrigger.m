% CY 9/27/2023: Deprecated old function for sync'ing. Replaced by
% outputVirmenHighLow

function [vr] = outputVirmenTrigger(vr)
outputSingleScan(vr.dio,[1]);
outputSingleScan(vr.dio,[0]);
end

