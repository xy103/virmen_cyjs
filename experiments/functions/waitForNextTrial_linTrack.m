function vr = waitForNextTrial_linTrack(vr)

if vr.inITI == 1
    
    %vr.worlds{vr.currentWorld}.backgroundColor = [0.5 0.5 0.5];
%     vr.worlds{vr.currentWorld}.backgroundColor = [0 0 0]; % 170613: make ITI color same as grey background
    %vr.filtSpeed = .8 * vr.filtSpeed + .2 * norm(vr.velocity);
    vr.itiTime = toc(vr.itiStartTime);

    if vr.itiTime > vr.itiDur
        
        vr.inITI = 0;
        vr = chooseNextWorld(vr);
%         vr.currentWorld=randi(2); % ranodmly choose one of two worlds
        vr.position = vr.worlds{vr.currentWorld}.startLocation;
        vr.worlds{vr.currentWorld}.surface.visible(:) = 1;
%         vr.worlds{vr.currentWorld}.backgroundColor = [vr.backgroundR_val vr.backgroundG_val vr.backgroundB_val];
        vr.dp = 0;
        vr.inRewardZone = 0;
        vr.trialTimer = tic;
        vr.trialStartTime = rem(now,1);
    end
end