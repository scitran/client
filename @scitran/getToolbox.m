function tbx = getToolbox(st, file, varargin)
% Read the toolbox file and return the toolbox object
%
% Syntax
%    tbx = st.getToolbox(file,...)
%
% Read a toolboxes json file from the Flywheel site.  Return the toolboxes
% object.
%
% Input (required)
%   file:          Toolboxes file name. or cell/struct (from search)
%
% Input (optional)
%   project name:  The project label (string)
%
% Output
%   tbx - the toolboxes object
%
% See also:  s_stToolboxes, s_tbxSave, scitran.toolbox
%
% Examples
%   tbx = st.getToolbox('dtiError.json','project name','DEMO');
%
% Examples in code
%
% BW, Scitran Team, 2017

% st = scitran('vistalab');
% Examples
%{
 file = st.search('file',...
    'filename','dtiError.json',...
    'project label exact','DEMO');
 tbx = st.getToolbox(file);

 url = tbx(1).github;   % This is the page on github

%}


%%
p = inputParser;

vFunc = @(x)(isstruct(x) || ischar(x) || (iscell(x) && (numel(x)==1)));
p.addRequired('file',vFunc);           % Either the file struct or its name

varargin = stParamFormat(varargin);
p.addParameter('projectname','', @ischar);  % Project label

p.parse(file,varargin{:});

file    = p.Results.file;
project = p.Results.projectname;

%% Set up the toolboxes object

% Get the struct from the cell array.
if iscell(file), file = file{1}; end

% Get the struct for the toolboxes file on the scitran site
if ischar(file)
    if isempty(project)
        error('Project label required when file is a string');
    else
        %  Get the file information, which is a cell array
        fileC = st.search('file',...
            'project label exact',project,...
            'filename',file);
        if length(fileC) ~= 1
            error('Problem identifying JSON toolbox file.  Search returned %d items\n',length(fileC));
        else
            fileS = fileC{1};   % Copy the struct
        end
    end
else
    % The struct was based, and that's what we want
    fileS = file;
end

% Download the json file containing the toolbox information.
tbxFile = st.downloadFile(fileS);

% Create the toolbox based on the repositories specified.
tbx = stToolbox(tbxFile);

end
