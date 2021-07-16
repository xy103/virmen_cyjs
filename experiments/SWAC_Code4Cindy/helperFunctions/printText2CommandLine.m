function vr = printText2CommandLine(vr)
if vr.numTrials > 0
    fprintf('\n Time elapsed: %s',datestr(now-vr.timeStarted, 'MM:SS')); % print the time elapsed 
else
    fprintf('\n Start time: %s',datestr(now, 'HH:MM:SS'))
end

fprintf('\n Current World: %s (%03.0f)\n',vr.world_names{vr.currentWorld},vr.currentWorld);
fprintf('\n Current trial: %03.0f\n', vr.numTrials + 1);
fprintf('\n Number of rewards: %03.0f\n', vr.numRewards);
if vr.numTrials > 0
    fprintf('\n Reward percentage: %03.2f\n', vr.numRewards/(vr.numTrials+1));
    fprintf('\n Number of switches: %3.0f\n', vr.Switches); % note this is a vector
end
%fprintf('\n LENGTH: %03.0f\n', vr.exper.variables.floorLength);
