function tbx = toolbox(st,file,varargin)
% Test for presence or install toolboxes from github
%
% Syntax
%    tbx = st.toolbox(file,...)
%
% Read a toolboxes json file from the Flywheel site.  
% If install, try to install as clone or zip
% Else test whether the toolbox repositories are on the matlab path
%
% Input (required)
%  file:  A string of toolbox filename
%           In this case, the project name must be specified
%         A cell or struct (returned by a search) that defines the toolbox
%           JSON file on the Flywheel site 
%
% Input (optional)
%   project:  The project label (string)
%   install:  Boolean on whether to install (default: true)
%   clone:    Boolean (false means zip install, true means git clone)
%
% Output
%   tbx - an array of toolboxes objects
%
% See also:  s_stToolboxes, s_tbxSave, scitran.getToolbox
%
% Examples in code
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

  % Creates the toolbox and tests whether they are on your path
  tbx = st.toolbox('aldit-toolboxes.json',...
        'project','ALDIT',...
        'install',false);  

  %  Returns a toolboxes struct without installing
  tbxFile = st.search('file','project label exact','DEMO','filename','dtiError.json')
  tbx = st.toolbox(tbxFile,'install',false);

  % Specify the filename.  Project label is required.
  tbx = st.toolbox('dtiError.json','project','DEMO','install',false);

%}


%%
p = inputParser;

vFunc = @(x)(isstruct(x) || ischar(x) || (iscell(x) && (numel(x)==1)));
p.addRequired('file',vFunc);   % Either the file struct or its name

% If only a name, then we need the project label
p.addParameter('project','', @ischar);        % Project label

% Decide whether and how to install
p.addParameter('install',true, @islogical);   % Install
p.addParameter('clone',false, @islogical);    % Zip by default, or clone

p.parse(file,varargin{:});

project = p.Results.project;
file    = p.Results.file;
install = p.Results.install;
clone   = p.Results.clone;

%% Set up the toolboxes object

% Get the struct for the toolboxes file on the scitran site
if ischar(file)
    tbx = st.getToolbox(file,'project name',project);
else
    tbx = st.getToolbox(file);
end

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