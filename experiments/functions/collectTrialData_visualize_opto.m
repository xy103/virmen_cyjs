function [vr,sessionData] = collectTrialData_visualize_opto(vr)
if vr.numTrials>1
    sessionData = [];
    for nTrial = 1:vr.numTrials
        try
            trialName = sprintf('Trial#%03.0f',nTrial);
            trialFileName = fullfile(vr.fullPath,trialName);
            load(trialFileName),
            behavData(end+1,:) = nTrial;
            sessionData = cat(2,sessionData,behavData);
            trialData(nTrial) = 1;
        end
    end
    fprintf('\n Concatenated Data for %03.0f Trials \n',sum(trialData)),
    sessionDataName = fullfile(vr.fullPath,'sessionData');
    experData = struct(vr.exper);
    save(sessionDataName,'sessionData','experData')
    % Make summary visualization
    switching_summary_visualization(sessionData,experData.variables)
    saveas(gcf,fullfile(vr.fullPath,'summary_visualization.png'))
end