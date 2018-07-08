function [localFileFull,val] = runFunction(st, mFile, varargin)
% Download and run a function stored on a Flywheel container
%
%  [localFileFull,val] = st.runFunction(mFileName, ...);
%
% Required inputs: 
%   mFile    - An mFileName filename (string) or 
%              A struct as returned from a search, defining the file, its
%              container type, and the container id
%
% Optional inputs
%  When a string you must specify the container
%     container Type - {project, session, acquisition, collection, analysis}
%     container ID   - Could use idGet() on a returned list or search
%   localDir         - Local directory for m-file (full path) 
%   params           - Struct of parameters for the mFile
%
% Return:
%   localFileFull  -  Local m-file (full path)
%   val            -  Returns from the  execution of the local m-file
%
% Examples in code
%
% BW, Scitran Team, 2017
%
% See also: s_stRunFunction.m

% st = scitran('stanfordlabs');
% Example 1
%{
 mFile = 'ecog_RenderElectrodes.m';
 [s,id] = st.exist('project','SOC ECoG (Hermes)');
 st.runFunction(mFile,'container type','project','container ID',id);
%}

%%
p = inputParser;
vFunc = @(x)(isstruct(x) || ischar(x));
p.addRequired('mFile',vFunc);

varargin = stParamFormat(varargin);

% Specify a local directory for the script.
p.addParameter('containerid','',@ischar);
p.addParameter('containertype','',@ischar);
p.addParameter('localdir',pwd,@ischar);    % Directory of local file
p.addParameter('params',[],@isstruct);

p.parse(mFile,varargin{:});
mFile          = p.Results.mFile;
containerID    = p.Results.containerid;
containerType  = p.Results.containertype;

localDir     = p.Results.localdir;    % Local file
params       = p.Results.params;
val          = [];   % Returns from the mFile will be here

%% Set up download information.  Always use string download type

if isstruct(mFile)
    % Set up the download variables
    containerType = file.parent.type;
    containerID   = idGet(mFile,'data type',containerType); % Not tested.
    filename      = mFile.file.name;
else
    filename = mFile;
    if isempty(containerType) || isempty(containerID)
        error('If file is a string, you must specify container information');
    end
end

%% Create the local m-file name

if ~exist(localDir,'dir'), mkdir(localDir); end

[~,n,e] = fileparts(filename);
if ~isequal(e,'.m'), error('Only m-files are accepted'); end
% The user either specified the destination file name or not
localFunction = sprintf('local_%s',n);
localFileFull = fullfile(localDir,[localFunction,'.m']);
    
%% Download the m-File to a local file 

if isstruct(mFile)
    st.downloadFile(mFile, ...
        'destination',localFileFull);
else
    st.downloadFile(mFile,...
        'containerType', containerType,...
        'containerID',   containerID, ...
        'destination',   localFileFull);
end
% edit(localFileFull)

%% Setup command with params

% If params is empty and we send it in, varargin looks it has one entry
% that is empty.  We don't want that.  So, we do an if/else
if isempty(params)
    cmd = sprintf('val = %s();',localFunction);
else
    cmd = sprintf('val = %s(params);',localFunction);
end

%% Change into directory, execute, and return
thisDir = pwd; chdir(localDir);
eval(cmd);     chdir(thisDir);

% edit(localFunction)
end




