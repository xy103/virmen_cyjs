function vr = chooseNextWorld(vr)
    if vr.biasCorrection && (vr.numTrials > 20)
            disp('Implementing bias correction.')
            fracLeft = mean(vr.leftTrials(end-20:end));
            p1 = (1 - fracLeft);
            if rand <= p1
                vr.currentWorld = 1;
            else
                vr.currentWorld = 2;
            end
    else
        vr.currentWorld = randi([1 vr.nWorlds]);
    end

end