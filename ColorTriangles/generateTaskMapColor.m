function generateTaskMapColor(taskMapFile,numTrialsTotal)
    % pre-generate a set of colors for each trial (not currently read
    % by the trial loop, but kept for consistency/bookkeeping)
    colorChoices = Shuffle(randi(360, numTrialsTotal,1));

    for tc = 1:numTrialsTotal
        clear map
        map = struct('trial',tc,...
            'triangColor',colorChoices(tc,1));
        taskMap{tc}=map;
    end
    taskMap = cell2mat(taskMap);

    % Save the task map
    save(taskMapFile,'taskMap');
end