function [dataFiles, acqID] = dataFileList(st,container, fileType, varargin)
% Find acquisition files that match a file type property
%
% Syntax:
%   [dataFiles, acqID] = st.dataFileList(containerType, container, fileType, varargin)
%
% Description
%   This method returns a list of all the data files within a container
%   (project, session, acquisition, collection) that match a particular
%   fileType attribute (e.g., 'archive', 'dicom', 'nifti').
%
%   dataFile means a file in an acquisition. (Flywheel calls these
%   acquisitionFiles). 
%
% Inputs
%   st            - scitran object
%   container     - a flywheel.model.Container (e.g., project, session, collection)
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
%}

%% Check args

p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('container');  % Could be a project or a session or an acquisition
p.addRequired('fileType',@ischar);
p.addParameter('summary',true,@islogical);

p.parse(st,container,fileType,varargin{:});

summary = p.Results.summary;

%%
switch class(container)
    case 'flywheel.model.Project'
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
            
    case 'flywheel.model.Session'
        % Top container is a session
        acq = container.acquisitions();
        nAcq = length(acq);
        % acq = st.list('acquisition',containerID);
        
        % Loop through all the acquisitions and select the files that
        % match
        % acqID = cell(length(acq),1);

        dataFiles = [];
        acqID = cell(nAcq,1);
        for aa=1:length(acq)
            % acqID{aa} = acq{aa}.id;
            % files = st.list('file',acq{aa}.id);
            % dataFiles{aa} = stFileSelect(files,'type',fileType,varargin{:});            
            dataFiles = cellMerge(dataFiles, stFileSelect(acq{aa}.files,'type',fileType));
            acqID{aa}     = acq{aa}.id;
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