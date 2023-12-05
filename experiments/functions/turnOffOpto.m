function turnOffOpto
% function to turn off dev1 analog output 1 for opto signal
    s = daq.createSession('ni'); % opto light signal
    s.addAnalogOutputChannel('dev1','ao1','Voltage');
    outputSingleScan(s,0); % set to 0 to avoid random light on
    print('Turned off opto signal!')
    delete(s)
end