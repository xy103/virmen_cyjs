function vr = handle_target_hiding_cyjs(vr)
% handle target hiding in switching task 
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

