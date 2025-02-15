
function code = CueOpto_AllChecker
% Code for the ViRMEn experiment DynSwitching that deliver optogenetic
% inhibition using ramped light within maze (ramping start in previous
% trial ITI) and inhibit the entire cue period

% 1/10/2025 CY a new version of cue opto inhibition and all trials have
% checker (to hopefully gauge from mice that struggle with sw90)

%   code = CueOpto_AllChecker  Returns handles to the functions that ViRMEn
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
    vr.behaviorData = nan(14,1e6); % overwrite init to allocate more memory

    % General setup functions
    vr = initDAQ(vr);

    % opto specific variables
    vr = initOpto_CY_SW(vr);
    % init variables specific to this instantiation of opto delivery
    vr.nextTrialOpto = false; % probabilistic opto delivery (updated at iteration 1 of each trial)
    vr.optoThreshold = eval(vr.exper.variables.optoThreshold); % probability/threshold for opto stimulation (only valid for maze inhibition)
    vr.optoTriggerPoint = eval(vr.exper.variables.optoTriggerPoint); % time point after which opto signal can be delivered
    vr.maxOptoTmBeforeRampDown = eval(vr.exper.variables.maxOptoTmBeforeRampDown);
    vr.rampDownStartSec = 0; % initialize to 0

%     Update Textboxes
    vr = printText2CommandLine(vr);
    if ~vr.isEphys % boolean
        vr = init_lickPlot(vr);
    end

end

% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
function vr = runtimeCodeFun(vr)    

    vr.totIterations = vr.totIterations + 1; % use total iteration to decide high low state, not trialIterations!
    
    vr = changeVirmenHighLow(vr); % 02/09/2022 CY changed pulses to high-low states
    
    % collect behavior data
    vr = collectBehaviorIter_full(vr);

    % at the start of the trial decide if the upcoming trial will have opto probailistically
    if vr.trialIterations == 1
        nextTrialOptoProb = rand;
        vr.nextTrialOpto = nextTrialOptoProb <= vr.optoThreshold;
    end

    % determine if optogenetics is given and save output voltage
    vr = checkForOptoDelivery_Cue(vr);

%     % Decrease velocity by friction coefficient (can be zero)
%     vr = adjustFriction(vr);

    % check for trial-terminating position and potentially deliver reward
    vr = checkforTrialEndPosition_switchingTask(vr); 

    % if we are in ITI, handle whether and when opto ramp initiates
    vr = checkITI_opto_start_Cue(vr);

    % if we are in ITI, handle trial reset and switch block logic
    % vr = checkITI_checker_v2_CY(vr);
    vr = checkITI_CA(vr);

    % If we are 1) in a non-visually-guided trial 2) cue not revealed 3) past tgt hidepoint and 4) in ISI 
    vr = handle_target_hiding_cyjs(vr); 
end


% --- TERMINATION code: executes after the ViRMEn engine stops.
function vr = terminationCodeFun(vr)
    if ~vr.debugMode
        outputSingleScan(vr.opto_ao,0);
        fprintf('Opto light off\n');
        stop(vr.ai),
        delete(vr.ai),
        delete(vr.ao),
        delete(vr.opto_ao)
        [vr,~] = collectTrialData_visualize_opto(vr); % save behavior data
    end
end
