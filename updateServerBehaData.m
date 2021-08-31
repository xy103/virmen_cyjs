function updateServerBehaData

% this function should be run at the end of each day
% the copying mechanism does not check for number of sessions for
% simplicity

localPath = 'D:\DATA\Cindy';
serverPath = '\\research.files.med.Harvard.edu\neurobio\HarveyLab\Tier1\Cindy\Behavior Data\CY\';

mouseServer = loadDirNoDot(fullfile(serverPath, '*'));
mouseServer_names = sort(str2double({mouseServer.name}));
% [mouseServer_names,idx] = sort(str2double({mouseServer.name}));
% mouseServer = mouseServer(idx);
% mouseServer(ismember(mouseServer_names,[0 1])) = []; % testing
mouseServer_names(ismember(mouseServer_names,[0 1])) = []; % testing


mouseLocal = loadDirNoDot(fullfile(localPath, '*'));
mouseLocal_names = sort(str2double({mouseLocal.name}));
% [mouseLocal_names,idx] = sort(str2double({mouseLocal.name}));
% mouseLocal = mouseLocal(idx);
% mouseLocal(ismember(mouseLocal_names,[0 1])) = []; % testing
mouseLocal_names(ismember(mouseLocal_names,[0 1])) = []; % testing

for this_mouse = mouseLocal_names
    % for each local mouse, check if it exist on server
    tempLocal = fullfile(localPath,num2str(this_mouse));
    tempServer = [serverPath,num2str(this_mouse),'\'];
    if ~ismember(this_mouse,mouseServer_names)
        % if not, copy the entire mouse folder onto server
        copyfile(tempLocal,tempServer)
        fprintf('Copied %s onto server\n',tempLocal)
    else % check if server files are up-to-date
        serverFiles = loadDirNoDot(tempServer);
        localFiles = loadDirNoDot(tempLocal);
        
        local_present_on_server = ismember({localFiles.name},{serverFiles.name});
        ind_to_copy = find(local_present_on_server==0);
        if ~isempty(ind_to_copy) % needs to copy
            for this_file = ind_to_copy
                this_local_path = fullfile(localFiles(this_file).folder,localFiles(this_file).name);
                copyfile(this_local_path,...
                    [serverFiles(1).folder,'\',localFiles(this_file).name])
                fprintf('Copied %s onto server\n',this_local_path)
            end
        end
    end
end
end

function out = loadDirNoDot(path)
out = dir(path);
out(ismember({out.name},{'.','..'}))=[];
end