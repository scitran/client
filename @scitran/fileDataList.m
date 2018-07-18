function dataFiles = fileDataList(st,containerType,containerID, fileType)
% Find the data files (files in an acquisition) that match a file type
%
%   st.fileDataList(containerType, containerID, fileType)
%
% Description
%   fileData is a file attached to an acquisition. We return a list of
%   all the files within a container (project, session, acquisition,
%   collection) that are inside of an acquisition and match a
%   particular fileType attribute (e.g., 'archive', 'dicom', 'nifti'). 
%
%
% Examples
%   Session name must be car, all the zip files
%   All the zip files in all the sessions
%   The obj files in the acquisition named Spaceship
%
% ZL/BW Vistasoft Team, 2018
%
% See also
%   scitran.list

% Examples:
%{
 st = scitran('stanfordlabs');
 h = st.projectHierarchy('Graphics assets');
 sessionID = h.sessions{1}.id;
 files = st.fileDataList('session',sessionID,'archive')
%}

%%
summary = true;

%%
switch containerType
    case 'session'
        % Top container is a session
        acq = st.list('acquisition',containerID);
        
        % Loop through all the acquisitions and select the files that
        % match
        dataFiles = cell(1,1);
        for ii=1:length(acq)
            files = st.list('file',acq{ii}.id);
            dataFiles{ii} = stFileSelect(files,'type',fileType);
        end
    case 'acquistion'
    otherwise
end

if summary
    fprintf('Found %d files of file type "%s"\n',length(dataFiles),fileType);
end

end