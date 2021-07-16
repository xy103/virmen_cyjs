%% A reboot of the switching task by Cindy Yuan and Josh Stern
% Based on DynSwitching_4Conds_Rig2 by Charlotte Arlte

function code = DynSwitching_CYJS
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

    % set directory for data to be stored in 
    vr = makeDir_CYJS(vr); % JS changed from makeDirSNC_CA_Camera_Rig2

    vr = init_switching_task(vr); % just encapsulating a lot of init code in this fn

    % General setup functions
    vr = initDAQ(vr);
    
%     Update Textboxes
    vr = printText2CommandLine(vr);
    %     vr = init_lickWindow(vr); % lick window?

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)    
%     % update lick info plot
%     vr = display_licks(vr);

    % collect behavior data
    vr = collectBehaviorIter_full(vr);

    % Decrease velocity by friction coefficient (can be zero)
    vr = adjustFriction(vr); % JS commented out, but may be important!!

    % check for trial-terminating position and potentially deliver reward
    vr = checkforTrialEndPosition_switchingTask(vr); 

    vr = checkITI_CA(vr);

    % If we are 1) in a non-visually-guided trial 2) cue not revealed 3) past tgt hidepoint and 4) in ISI 
    if (ismember(vr.currentWorld, 1:4)) && ~vr.targetRevealed && (vr.position(2) > vr.hideCuePast) && ~vr.inITI
        vr.targetRevealed = 1;
        % Hide cue walls in target zone
        vr.worlds{vr.currentWorld}.surface.vertices(2,vr.cueToHide{vr.currentWorld}) = ...
            100 + vr.worlds{vr.currentWorld}.surface.vertices(2,vr.cueToHide{vr.currentWorld});
        vr.worlds{vr.currentWorld}.surface.vertices(2,vr.blankToHide{vr.currentWorld}) = ...
            -100 + vr.worlds{vr.currentWorld}.surface.vertices(2,vr.blankToHide{vr.currentWorld});
    elseif vr.targetRevealed && vr.inITI  %if we are in the ITI
        vr.targetRevealed = 0;
        % Reset / reveal cue ID once in reward zone
        vr.worlds{vr.currentWorld}.surface.vertices(2,vr.cueToHide{vr.currentWorld}) = ...
            -100 + vr.worlds{vr.currentWorld}.surface.vertices(2,vr.cueToHide{vr.currentWorld});
        vr.worlds{vr.currentWorld}.surface.vertices(2,vr.blankToHide{vr.currentWorld}) = ...
            100 + vr.worlds{vr.currentWorld}.surface.vertices(2,vr.blankToHide{vr.currentWorld});
end


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
if ~vr.debugMode
    stop(vr.ai),
    delete(vr.ai),
    delete(vr.ao),
    [vr,~] = collectTrialData(vr); % save behavior data
end
