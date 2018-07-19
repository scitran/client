function [dataFiles, acqID] = fileDataList(st,containerType,containerID, fileType, varargin)
% Find the data files (files in an acquisition) that match a file type
%
%   [dataFiles, acqID] = st.fileDataList(containerType, containerID, fileType, varargin)
%
% Description
%   fileData refers to a file attached to an acquisition. We return a list
%   of all the files within a container (project, session, acquisition,
%   collection) that are in an acquisition and match a particular fileType
%   attribute (e.g., 'archive', 'dicom', 'nifti').
%
% Inputs
%   st - scitran object
%   containerType - the big container (e.g., project, session, collection)
%   containerID   - string
%   fileType      - dicom, nifti, archive, source code, ...
%
% Optional key/value pairs
%    info field label and value
%
% Examples - see code
%
% ZL/BW Vistasoft Team, 2018
%
% See also
%   scitran.list

% Examples:
%{
 % All the zip files in a session
 st = scitran('stanfordlabs');
 h = st.projectHierarchy('Graphics assets');
 sessionID = h.sessions{1}.id;
 files = st.fileDataList('session',sessionID,'archive')
%}
%{
 % All the nifti files in a project
 st = scitran('stanfordlabs');
 project = st.search('project','project label exact','TBI: NeuroCor');
 dataFiles = st.fileDataList('project',idGet(project{1},'data type','project'),'nifti')
%}
%{
  % All the archive files in an acquisition
  st = scitran('stanfordlabs');
  h = st.projectHierarchy('VWFA');
%}

%%
summary = true;
%%
switch containerType
    case 'project'
        % containerID = '56e9d386ddea7f915e81f703';
        project = st.search('project','project id',containerID);
        h = st.projectHierarchy(project{1}.project.label);
        dataFiles = cell(1,1);

        % The indexing on dataFiles is ridiculous.  I need to understand
        % the cell array indexing better and do the right thing (BW).
        for ss = 1:length(h.sessions)
            acq = h.acquisitions{ss};  % Acq for this session
            for aa = 1:length(acq)
                files = st.list('file',acq{aa}.id);
                dataFiles{ss}{aa} = stFileSelect(files,'type',fileType,varargin{:});
            end
        end
        
            
    case 'session'
        % Top container is a session
        acq = st.list('acquisition',containerID);
        
        % Loop through all the acquisitions and select the files that
        % match
        dataFiles = cell(1,1);
        for ii=1:length(acq)
            acqID{ii} = acq{ii}.id;
            files = st.list('file',acq{ii}.id);
            dataFiles{ii} = stFileSelect(files,'type',fileType,varargin{:});
        end
    case 'acquistion'
    otherwise
end

if summary
    total = 0;
    for ii=1:length(dataFiles)
        total = total + length(dataFiles{ii});
    end
    fprintf('Found %d files of file type "%s"\n',total,fileType);
end

end