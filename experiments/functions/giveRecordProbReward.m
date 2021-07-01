function [vr] = giveRecordProbReward(vr, probability)
    if rand <= probability
        vr = giveReward(vr, vr.nRewards);
        vr.behaviorData(9,vr.trialIterations) = vr.nRewards;
        vr.numRewards = vr.numRewards + vr.nRewards;
    else
        vr.behaviorData(9,vr.trialIterations) = 0;
    end
end
