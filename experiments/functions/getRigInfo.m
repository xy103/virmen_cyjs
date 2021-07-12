
function ops = getRigInfo(varargin)
%Code from Noah's github rep, eddited by SS March 2018
                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I am altering this to be a much more general functio
%n that can be called
% by other functions (such as calibration and testing functions)
% either pass in rigName string, or no variables or empty string. second
% two cases matlab will try to determine rig automatically

switch nargin
    case 1
        rigName = varargin{1};
    case 0
        rigName = '0'; % flag to find automatically
end

if isempty(rigName)
    rigName = '0';
end

%
switch rigName      
    case 'Optorig' % Photostimulation Rig
        ops.rigName = rigName;
        
        % daq settings
        ops.dev = 'Dev2';
        ops.photoInhibTrig = 'Port0/Line1';
        ops.comPortTeensy = 'COM12';
        
        % ball sensor offset
        ops.ballSensorOffset = [ 1.6399 1.642 1.645 ];
        ops.forwardGain = -410;
        ops.viewAngleGain = 3.5;
        
        % reward calibration through init_variables.h
        ops.useTeensyReward = true;
        
        % base data directory settings
        ops.dataDirectory = 'C:\DATA\Carissa';
        
    case 'Behavior_rig1'
        ops.rigName = rigName;
        
        % daq settings
        ops.dev = 'dev1';
        
        % ball sensor offset
        ops.ballSensorOffset = [1.6505, 1.652, 1.655];
        ops.forwardGain = -126;
        ops.viewAngleGain = 3.95;
        
        % reward calibration through init_variables.h
        ops.useTeensyReward = false;
        ops.rewardPulseDuration = 0.055*1;
        
        % base data directory settings
        ops.dataDirectory = 'D:\DATA\Jonathan';
        
    case 'Behavior_rig2'
        ops.rigName = rigName;
        
        % daq settings
        ops.dev = 'dev1';
        
        % ball sensor offset
        ops.ballSensorOffset = [1.6449, 1.652, 1.65];
        ops.forwardGain = -151;
        ops.viewAngleGain = 4.47;
        
        % reward calibration through init_variables.h
        ops.useTeensyReward = false;
        ops.rewardPulseDuration = 0.055*2;
        
        % base data directory settings
        ops.dataDirectory = 'D:\DATA\Jonathan';
        
    case 'Rotation_scope'
        ops.rigName = rigName;
        
        % daq settings
        ops.dev = 'dev1';
        
        % ball sensor offset
        ops.ballSensorOffset = [1.4942, 1.4965, 1.5]; % old ball: [1.4946, 1.4965, 1.5];
        ops.forwardGain = -128; % old ball: -142
        ops.viewAngleGain = 4.18;
        
        
        % reward calibration through init_variables.h
        ops.useTeensyReward = false;
        ops.rewardPulseDuration = 0.07*1;
        
        % base data directory settings
        ops.dataDirectory = 'D:\DATA\Jonathan';        

    case 'Loki'
        ops.rigName = rigName;
        
        % daq settings
        ops.dev = 'Dev1';
        
        % ball sensor offset
        ops.ballSensorOffset = [1.5071, 1.52, 1.511];
        ops.forwardGain = -139;
        ops.viewAngleGain = 4.08;
        
        % reward calibration through init_variables.h
        ops.useTeensyReward = false;
        ops.rewardPulseDuration = 0.030;
        
        % base data directory settings
        ops.dataDirectory = 'D:\DATA\Destinee';
    case 'Anna_2PStim'
        ops.rigName = rigName;
        
        % daq settings
        ops.dev = 'dev1';
        
        % ball sensor offset
        ops.ballSensorOffset = [1.6477, 1.65, 1.654];
        ops.forwardGain = -110;
        ops.viewAngleGain = 3.44;
        
        % reward calibration through init_variables.h
        ops.useTeensyReward = false;
        ops.rewardPulseDuration = 0.07;
        
        % base data directory settings
        ops.dataDirectory = 'D:\DATA\Jonathan'; 
        
    case 'CYJS_BehaviorRig'
        ops.rigName = rigName;
        
        % daq settings
        ops.dev = 'dev1';
        
        % ball sensor offset
        ops.ballSensorOffset = [1.6448    1.6492    1.6496]; % calibrated 7/9/21
        ops.forwardGain = -185; % calibrated 7/12/21 for 40 PSI
        ops.sideGain = 100; 
        ops.viewAngleGain = 3.44;
        
        % reward calibration through init_variables.h
        ops.useTeensyReward = false;
        ops.rewardPulseDuration = 0.055; % calibrated 7/12/21 for h20 at 10 mL
        
        % base data directory settings
        ops.dataDirectory = 'D:\DATA\Cindy'; 
    
    case 'CYJS_EphysRig'
        ops.rigName = rigName;
        
        % daq settings
        ops.dev = 'dev1';
        
        % ball sensor offset
        ops.ballSensorOffset = [1.6509    1.6557    1.6561];
        ops.forwardGain = -175;
        ops.sideGain = 100; 
        ops.viewAngleGain = 3.44;
        
        % reward calibration through init_variables.h
        ops.useTeensyReward = false;
        ops.rewardPulseDuration = 0.07;
        
        % base data directory settings
        ops.dataDirectory = 'D:\DATA\Cindy'; 

    case '0' % try to find name automatically
        disp('Trying to identify computer automatically....');
        % try to determine rig name automatically
        name = getenv('COMPUTERNAME');
        switch name
            case 'HARVEYRIG2'
                rigName = 'Optorig';
            case 'DESKTOP-I7FE9SI'
                rigName = 'Behavior_rig1';
            case 'DESKTOP-SOH909T'
                rigName = 'Behavior_rig2';
            case 'DESKTOP-3HCFBPM'
                rigName = 'Rotation_scope'; 
            case 'DESKTOP-66LHJNN'
                rigName = 'Loki';
            case 'DESKTOP-ID06G8C'
                rigName = 'Anna_2PStim';
            case 'DESKTOP-5HC5CBD' 
                rigName = 'CYJS_BehaviorRig';
            case 'DESKTOP-U9I9DDP'
                rigName = 'CYJS_EphysRig';
            otherwise
                error('Could not find this rig! Check getRigInfo.m');
        end
        disp(['This computer is ' rigName]);
        ops = getRigInfo(rigName);
        
    otherwise
        error('Could not find this rig! Check getRigInfo.m'); 
        
end

end