function vr = printText2CommandLine_linearTrack(vr)
if vr.numTrials > 0
    fprintf('\n Time elapsed: %s \t',datestr(now-vr.timeStarted, 'HH:MM:SS')); % print the time elapsed 
else
    fprintf('\n Start time: %s \n',datestr(now, 'HH:MM:SS'))
end
end