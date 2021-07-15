function code = T_maze_headingDriftPulse
% T_maze   Code for the ViRMEn experiment T_maze.
%   code = T_maze   Returns handles to the functions that ViRMEn
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
vr = makeVirmenDir(vr);
vr = initTMaze(vr);
vr = initDAQ(vr);

% Maze specific parameters
vr.totalMazeLength = vr.floorLength + vr.cueLength;
vr.YTrigger = vr.totalMazeLength * 2;
vr.fractionMaze = 1.0;
vr.inDriftPulse = 0;
vr.dp4offset = 0;

vr.fractionTrials = 0.3;
vr.driftPulseSd = 0.375;
vr.driftPulseMu = vr.driftPulseSd * 4;
vr.driftPulseHeight = 0.06;


% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)
vr = outputVirmenTrigger(vr);
vr = collectBehaviorIter_TMaze(vr, vr.inDriftPulse, vr.dp4offset);
vr = headingDriftPulse(vr);
%vr = adjustFriction_dan(vr);
vr = checkForManualReward(vr); % Deliver reward if 'r' key pressed
vr = checkforTrialEndPosition_Tmaze(vr);
vr = waitForNextTrial(vr);

if isTrialStart(vr)
    vr = initTrial(vr);
    vr.YTrigger = chooseNextYPosition(vr, vr.fractionTrials, vr.fractionMaze);
    vr.inDriftPulse = 0;
    vr.dp4offset = 0;
    % Randomly choose pulse going left or right
    pulseDirection = (randi([0 1]) -0.5)*2; % -1 or 1
    vr.driftPulseHeight = vr.driftPulseHeight * pulseDirection;
end

% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
vr = clearAnalogChannels(vr);
[vr,sessionData] = collectTrialData(vr);
%vr = makeTMazeFigs(vr,sessionData);
