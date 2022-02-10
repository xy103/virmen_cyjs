function [vr] = changeVirmenHighLow(vr)
% Flip high and low state on each new vr iteration
outputSingleScan(vr.dio,[mod(vr.trialIterations,2)]);
% fprintf('Current iter %i dig state %i \n',current_iter,mod(current_iter,2));
end

