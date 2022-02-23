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
end

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
    vr = init_lickPlot(vr);
   %  vr = initLivePlots(vr);
end

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)    
%     vr = outputVirmenTrigger(vr); %08/20/21 CY added to aid sync b/w virmen and ephys
    vr.totIterations = vr.totIterations + 1; % use total iteration to decide high low state, not trialIterations!
    
    vr = changeVirmenHighLow(vr); % 02/09/2022 CY changed pulses to high-low states
    
    % collect behavior data
    vr = collectBehaviorIter_full(vr);

    % Decrease velocity by friction coefficient (can be zero)
    vr = adjustFriction(vr);

    % check for trial-terminating position and potentially deliver reward
    vr = checkforTrialEndPosition_switchingTask(vr); 

    % if we are in ITI, handle trial reset and switch block logic
    vr = checkITI_CA(vr);

    % If we are 1) in a non-visually-guided trial 2) cue not revealed 3) past tgt hidepoint and 4) in ISI 
    vr = handle_target_hiding_cyjs(vr); 
end


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
    if ~vr.debugMode
        stop(vr.ai),
        delete(vr.ai),
        delete(vr.ao),
        [vr,~] = collectTrialData_visualize(vr); % save behavior data
    end
end
