function nextYPosition = chooseNextYPosition(vr, fractionTrials, fractionMaze)

    if ~exist('fractionMaze', 'var')
        fractionMaze = 1.0;
    end
    % Choose Y position for fraction of next trials
    if rand <= fractionTrials
    	nextYPosition = randi([0 vr.totalMazeLength*fractionMaze]);
    else
    	nextYPosition = vr.totalMazeLength * 2; % gain change never triggered
    end
end