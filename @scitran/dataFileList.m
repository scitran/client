function [dataFiles, acqID] = dataFileList(st,containerType, containerID, fileType, varargin)
% Find the data files that match a specific file type property
%
%   [dataFiles, acqID] = st.dataFileList(containerType, containerID, fileType, varargin)
%
% Description
%   dataFile refers to a file in an acquisition. (Flywheel sometimes calls
%   these acquisitionFiles). There are times we want to find all the data
%   files within a session or a project. This method returns a list of all
%   the data files within a container (project, session, acquisition,
%   collection) and match a particular fileType attribute (e.g., 'archive',
%   'dicom', 'nifti').
%
% Inputs
%   st - scitran object
%   containerType - a container (e.g., project, session, collection)
%   containerID   - string
%   fileType      - dicom, nifti, archive, source code, ...
%
% Optional key/value pairs
%   summary - print a summary (default is true)
%   info field label and value - Not yet implemented
%
% Examples - see code in the method
%
% ZL/BW Vistasoft Team, 2018
%
% See also
%   scitran.list

% Examples:
%{
 % All the zip files ('archive') in a session
 st = scitran('stanfordlabs');
 h = st.projectHierarchy('Graphics assets');
 sessionID = h.sessions{1}.id;
 files = st.dataFileList('session',sessionID,'archive')
%}
%{
 % All the nifti files in a project
 st = scitran('stanfordlabs');
 project = st.search('project','project label exact','TBI: NeuroCor');
 dataFiles = st.dataFileList('project',idGet(project{1},'data type','project'),'nifti')
%}

%%
p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('containerType',@ischar);
p.addRequired('containerID',@ischar);
p.addRequired('fileType',@ischar);
p.addParameter('summary',true,@islogical);

p.parse(st,containerType,containerID,fileType,varargin{:});

summary = p.Results.summary;

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
        acqID = cell(length(acq),1);
        for ii=1:length(acq)
            acqID{ii} = acq{ii}.id;
            files = st.list('file',acq{ii}.id);
            dataFiles{ii} = stFileSelect(files,'type',fileType,varargin{:});
        end
        
    case 'acquistion'
        disp('Acquisition: Not yet implemented');
        
    case 'collection'
        disp('Collection: Not yet implemented');
        
    otherwise
        error('Unknown container type %s',containerType);
end

if summary
    total = 0;
    for ii=1:length(dataFiles)
        total = total + length(dataFiles{ii});
    end
    fprintf('Found %d files of file type "%s"\n',total,fileType);
end

end