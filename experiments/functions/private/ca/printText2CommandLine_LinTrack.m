function vr = printText2CommandLine_LinTrack(vr)

fprintf(datestr(now-vr.timeStarted, 'MM.SS')); % print the time elapsed 

fprintf('\n TRIALS: %03.0f\n', vr.numTrials);
fprintf('\n REWARDS: %03.0f\n', vr.numRewards);
if vr.numTrials > 0
    fprintf('\n PRCT: %03.2f\n', vr.numRewards/vr.numTrials);
    %fprintf('\n SWITCHES: %3.0f\n', vr.Switches);
else
    fprintf('\n PRCT: 0\n');
end
%fprintf('\n LENGTH: %03.0f\n', vr.exper.variables.floorLength);
