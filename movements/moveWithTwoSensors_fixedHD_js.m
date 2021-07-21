function velocity = moveWithTwoSensors_fixedHD_js(vr)
    global daqData
    global mvData
    velocity = [0 0 0 0];

    if isempty(daqData)
        return
    end
    % Access global mvData
    % Teensy can send voltage between 0 and 3.3V, so that ~1.65 V
    % corresponds to no movement. This voltage needs calibration
    % because there is subtle fluctuations from day to day.
    %disp(size(daqData));
    data = daqData(1:3) - vr.ops.ballSensorOffset;

    % disp(data);
    % data
    % 1: pitch
    % 2: roll
    % 3: yaw

    % Update velocity
    alpha = vr.ops.forwardGain * vr.pitchGain;
    flip = 1; % set to 1 if the mirror flips right and left in Virme9n

    if flip == true
        velocity(1) = -data(2) * vr.ops.sideGain;
    else
        velocity(1) = data(2) * vr.ops.sideGain;
    end
    velocity(2) = data(1) * vr.ops.forwardGain * 20;
    velocity(4) = 0; % fix head direction
end