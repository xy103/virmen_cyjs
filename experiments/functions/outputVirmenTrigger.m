function [vr] = outputVirmenTrigger(vr)
outputSingleScan(vr.dio,[1]);
outputSingleScan(vr.dio,[0]);
end

