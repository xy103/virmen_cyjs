 function code = linear_track_rectangleMiddle_CYJS
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
vr.ops = getRigInfo();
vr = makeVirmenDir(vr); % creates a directory to store data to

% linear track initialization
% background color
vr.backgroundR_val = eval(vr.exper.variables.backgroundR_val);
vr.backgroundG_val = vr.backgroundR_val;
vr.backgroundB_val = vr.backgroundR_val;

% evaluate the width of the TargetChecker field
vr.frac_TargetWall = eval(vr.exper.variables.frac_TargetWall);
vr.floorWidth = eval(vr.exper.variables.floorWidth);
vr.floorLength = eval(vr.exper.variables.floorLength);
vr.ML_RewardZone = -(vr.floorWidth*vr.frac_TargetWall)/2 : (vr.floorWidth*vr.frac_TargetWall)/2;

% set parameters
vr.rewardDelay = .2; % delay of 1s from reward zone entry until reward trigger
vr.friction = 0;  %.5 value adjust friction in collisions
vr.itiCorrect = 1;  
vr.itiMiss = 0;
vr.mazeLength = eval(vr.exper.variables.floorLength);
vr.nWorlds = length(vr.worlds);
vr.alpha = eval(vr.exper.variables.alpha_mov);
vr.biasCorrection = false; 
% Gain
vr.yawGain = 1;
vr.pitchGain = 1;

vr = initDAQ(vr);
vr = initCounters(vr);  
vr.currentWorld = randi(vr.nWorlds); % randomly choose one of the available worlds

vr = initLivePlots(vr); 


% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)
vr = outputVirmenTrigger(vr); %08/20/21 CY added to aid sync b/w virmen and ephys
vr = collectBehaviorIter_TMazeCYJS(vr); % collect behavior data
vr = adjustFriction(vr); % Decrease velocity by friction coefficient (can be zero)
vr = checkForManualReward(vr); % Deliver reward if 'r' key pressed
vr = checkforTrialEndPosition_linearTrackRectangleMiddle(vr); % Check for end position, paying attn to lateral
vr = waitForNextTrial_linTrack(vr); % wait for next trial

% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
if ~vr.debugMode
    stop(vr.ai),
    delete(vr.ai),
    delete(vr.ao),
end
[vr,~] = collectTrialData(vr);
