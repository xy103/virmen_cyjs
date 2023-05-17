function code = OptoDarkWorld
% CY: Opto version, DarkWorld has nothing in it to display and randomly distributes
% reward if mouse is running and randomly gives optogenetic stimulation
% with pre determined parameters
%   code = DarkWorld   Returns handles to the functions that ViRMEn
%   executes during engine initialization, runtime and termination.

% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT


% --- INITIALIZATION code: executes before the ViRMEn engine starts.
function vr = initializationCodeFun(vr)
vr.debugMode = false;
vr.ops = getRigInfo(); % contains info on reward magnitude
vr = makeVirmenDir(vr); % creates a directory to store data to
vr.taskName = 'dark';

vr.currentWorld = 1; % fixed at 1
vr = initDAQ(vr); % includes opto_ao init
vr = initCounters(vr);  % CY: disable? won't need most of them
vr.behaviorData = nan(14,1e6); % overwrite init

vr.iterSinceLastRew = inf; % new counter specific to this experiment

% custom variables that can be changed in virmen gui
vr.runningThres = eval(vr.exper.variables.runningThres);
vr.rewardProb = eval(vr.exper.variables.rewardProb);
vr.minIterBetweenRew = eval(vr.exper.variables.minIterBetweenRew);
vr.maxRewAllowed = eval(vr.exper.variables.maxRewAllowed);

% opto specific variables
vr = initOpto_CY(vr);

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)
% vr = outputVirmenTrigger(vr); % 08/20/21 CY added to aid sync b/w virmen and ephys
vr.totIterations = vr.totIterations + 1; % use total iteration to decide high low state, not trialIterations!
vr = changeVirmenHighLow(vr); % 02/09/2022 CY changed pulses to high-low states
vr = collectBehaviorIter_TMazeCYJS(vr); % collect behavior data

% vr = checkForManualReward(vr); % Deliver reward if 'r' key pressed
vr = checkForDarkWorldRunningRew(vr); % Check for forward velocity, randomly dispense reward if running above threshold
% stop the experiment if max amount of rewards received
% if vr.numRewards >= vr.maxRewAllowed
%     vr.experimentEnded = 1;
% end

% determine if optogenetics is given and save output voltage
vr = checkForOptoDelivery(vr);


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
if ~vr.debugMode
    stop(vr.ai),
    delete(vr.ai),
    delete(vr.ao),
end
vr = saveTrialData(vr); % dark world is one big trial
