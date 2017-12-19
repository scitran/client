function [tbx, valid] = getToolbox(st, file, varargin)
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
%   validate:      Check that the toolboxes are installed
%
% Output
%   tbx - the toolboxes object
%   valid - True if toolboxes are validated
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
p.addParameter('validate',false, @islogical);  % Project label

p.parse(file,varargin{:});

file    = p.Results.file;
project = p.Results.projectname;
validate = p.Results.validate;

%% Set up the struct defining the JSON toolbox on Flywheel

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
            error('Problem - search returned %d items\n',length(fileC));
        else
            fileS = fileC{1};   % Copy the struct
        end
    end
else
    % The struct was passed in
    fileS = file;
end

%% Read the JSON data and create the toolbox

s   = st.read(fileS);  % Returns the JSON data as a struct
tbx = stToolbox(s);    % Creates the toolbox

%% May validate that they exist on the path

if validate, valid = st.toolboxValidate(tbx,'verbose',true); end

end
