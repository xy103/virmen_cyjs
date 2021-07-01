function vr = initTrial(vr)
    vr.inITI = 0;
    vr = chooseNextWorld(vr);
    vr = setWorld(vr, vr.currentWorld);
    vr.dp = 0;
    vr.inRewardZone = 0;
    vr.trialTimer = tic;
    vr.trialStartTime = rem(now,1);
end