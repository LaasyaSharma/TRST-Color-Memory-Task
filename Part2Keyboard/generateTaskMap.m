function generateTaskMap(taskMapFile,numTrialsTotal)

    %shuffle all orientations for both of the triangles
    orientations = Shuffle(randi(360, numTrialsTotal,1));

    for tc = 1:numTrialsTotal
        clear map
        map = struct('trial',tc,...
            'triangOrientation',orientations(tc,1));
        taskMap{tc}=map;
    end

    taskMap = cell2mat(taskMap);

    % Save the task map
    save(taskMapFile,'taskMap');
end