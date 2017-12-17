function tbx = toolbox(st,varargin)
% Install toolboxes from github repositories.
%
% Syntax
%    tbx = st.toolbox(file,...)
%
% Read a toolboxes json file from the Flywheel site.  Then either install
% the toolbox or not, according to the parameters.
%
% Input parameters
%   project:  The project label (string)
%   tbxFile:  This is either a struct defining the toolbox JSON file on the
%             scitran site (returned by a search), or it is simply the 
%             name of the JSON toolbox file in the project (default is
%             'toolboxes.json'). 
%   install:  Boolean on whether to install (default: true)
%   clone:    Boolean (false means zip install, true means git clone)
%
% Output
%   tbx - the toolboxes object
%
% See also:  s_stToolboxes, s_tbxSave, scitran.toolbox
%
% BW, Scitran Team, 2017

% Programming TODO:  If the repository is on the path as a zip download, we
% return that the repository is installed even if the person asked for a
% git clone download.  We should find a test of whether the download is a
% git clone or a zip download.
%  
%
% Examples
%{
  st = scitran('vistalab');

  % Creates the toolbox .json file from this project page
  tbx = st.toolbox('aldit-toolboxes.json','project','ALDIT','install',false);  
  tbx.install;

  % Specify the filename
  tbx = st.toolbox('dtiError.json','project','ALDIT','install',true);

  %  Returns a toolboxes struct without installing
  tbxFile = st.search('files','project label','Diffusion Noise Analysis','filename','toolboxes.json')
  tbx = st.toolbox('file',tbxFile{1},'install',false);
%}


%%
p = inputParser;

vFunc = @(x)(isstruct(x) || ischar(x));
p.addRequired('file',vFunc);   % Either the file struct or its name

% If only a name, then we need the project label
p.addParameter('project','', @ischar);        % Project label

% Decide whether and how to install
p.addParameter('install',true, @islogical);   % Install
p.addParameter('clone',false, @islogical);    % Zip by default, or clone

p.parse(varargin{:});

project = p.Results.project;
file    = p.Results.file;
install = p.Results.install;
clone   = p.Results.clone;

%% Set up the toolboxes object

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

%% Do or don't install, using the toolboxes object install method

% If we install, the toolbox object checks if the path already contains the
% test function.  If not, then it installs from the github repository
% specified in the toolbox file structure.  
%
% Originally, we installed using git clone.  But going forward, we will
% probably create a tmp directory, download the zip file for each
% repository, and unzip them all into the tmp directory.  We will then add
% the tmp directory to the user's path.

nTbx = length(tbx);
if ~install
    % Testing only
    for ii=1:nTbx
        cmd = tbx(ii).testcmd;
        fprintf('Testing %s (repo %s) ... ',cmd, tbx(ii).gitrepo.project);
        if isempty(which(cmd)), fprintf('not found.\n'); 
        else,                   fprintf('found %s.\n',which(cmd));
        end
    end
    return;
else
    % Either a zip install or a git clone install
    if clone,     for ii=1:nTbx, tbx(ii).clone;   end
    else,         for ii=1:nTbx, tbx(ii).install; end
    end
end

end

%% 