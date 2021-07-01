function [vr] = clearAnalogChannels(vr)
if ~vr.debugMode
    stop(vr.ai),
    delete(vr.ai),
    delete(vr.ao),
    daqreset;
end

end

