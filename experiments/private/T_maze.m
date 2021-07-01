function code = T_maze
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
vr = makeVirmenDir_dan(vr);
vr = initTMaze_dan(vr);
vr = initDAQ_dan(vr);
vr.currentWorld = randi(2);

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)
vr = outputVirmenTrigger(vr);
vr = collectBehaviorIter_TMaze_dan(vr);
%vr = adjustFriction_dan(vr);
vr = checkForManualReward(vr); % Deliver reward if 'r' key pressed
vr = checkforTrialEndPosition_Tmaze(vr);
vr = waitForNextTrial_dan(vr);

% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
vr = clearAnalogChannels(vr);
[vr,sessionData] = collectTrialData_dan(vr);
%vr = makeTMazeFigs(vr,sessionData);
