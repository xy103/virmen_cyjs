
 function code = SC_linearTrack_CA_Rig2
% Linear Track   Code for the ViRMEn experiment Linear Track.
%   code = Linear Track   Returns handles to the functions that ViRMEn
%   executes during engine initialization, runtime and termination.

% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT


% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)

vr.debugMode = false;
vr = makeDirSNC_CA_Rig2(vr); % creates a directory to store data to

% background color
vr.backgroundR_val = eval(vr.exper.variables.backgroundR_val);
vr.backgroundG_val = vr.backgroundR_val;
vr.backgroundB_val = vr.backgroundR_val;

% evaluate the width of the TargetChecker field
vr.frac_TargetWall = eval(vr.exper.variables.frac_TargetWall);
vr.floorWidth = eval(vr.exper.variables.floorWidth);
vr.ML_RewardZone = -(vr.floorWidth*vr.frac_TargetWall)/2 : (vr.floorWidth*vr.frac_TargetWall)/2;

% set parameters
vr.rewardDelay = 1; % delay of 1s from reward zone entry until reward trigger
%vr.mvThresh = 15;  
vr.friction = 0;  %.5 value adjust friction in collisions
vr.itiCorrect = 1;  
vr.itiMiss = 0;
vr.mazeLength = eval(vr.exper.variables.floorLength);
vr.nWorlds = length(vr.worlds);
vr.alpha = eval(vr.exper.variables.alpha_mov);

% vr = initTextboxes(vr); % not working, bug in current Matlab version
vr = initDAQ_new(vr);
vr = initCounters(vr);  
vr.currentWorld = randi(vr.nWorlds); % randomly choose one of the available worlds

%vr = initStepperMotor(vr); % initialise the stepper motor for syringe pump reward delivery 
vr = init_lickWindow(vr);


% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)

% update lick info plot
vr = display_licks(vr);

% collect behavior data
vr = collectBehaviorIter_LinTrack(vr);

% Decrease velocity by friction coefficient (can be zero)
vr = adjustFriction(vr);

% Deliver reward if 'r' key pressed
manualReward = vr.keyPressed == 82; %'r' key
if manualReward
    vr.behaviorData(9,vr.trialIterations) = 1;
    vr.numRewards = vr.numRewards + 1;
    vr = giveReward(vr,1);
    %vr.Rewards = [vr.Rewards 1]; % append the vector containing binary reward info per trial

end

% check for trial-terminating position and deliver reward
if vr.inITI == 0 && (vr.position(2) > vr.mazeLength + 5)
  
    % Disable movement
    vr.dp = 0*vr.dp;
    % Enforce Reward Delay
    if ~vr.inRewardZone
        vr.rewStartTime = tic;
        vr.inRewardZone = 1;
    end
    
    vr.rewDelayTime = toc(vr.rewStartTime);
    if vr.rewDelayTime > vr.rewardDelay   
        
    % check if mouse is in reward zone mediolaterally 
    if vr.frac_TargetWall < 1
        if vr.position(1) >= min(vr.ML_RewardZone) && vr.position(1) <= max(vr.ML_RewardZone)
            % give reward and store reward time
            vr.behaviorData(9,vr.trialIterations) = 1;
            vr.numRewards = vr.numRewards + 1;
            vr = giveReward(vr,1);
        else
            vr. behaviorData(9,vr.trialIterations) = 0;
        end
    end
       
        vr.itiDur = vr.itiCorrect;
        vr = endVRTrial(vr);
    else
        vr.behaviorData(9,vr.trialIterations) = 0;
        vr.behaviorData(8,vr.trialIterations) = -1;
    end
else
    vr.behaviorData(9,vr.trialIterations) = 0;
end

% Check to see if ITI has elapsed, and restart trial if it has
vr = waitForNextTrial_CA_Rig2(vr);

% Update Textboxes: text boxes in VR window not working with new MATLAB version, so to command line instead
vr = printText2CommandLine_LinTrack(vr);


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
if ~vr.debugMode
    stop(vr.ai),
    delete(vr.ai),
    delete(vr.ao),
end
[vr,sessionData] = collectTrialData(vr);
vr = makeLinearTrackFigs(vr,sessionData);