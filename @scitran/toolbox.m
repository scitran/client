function tbx = toolbox(st,varargin)
% Install toolboxes from github repositories.
%
%    tbx = st.toolbox('project',...,'file',...,'install',logical,'clone',logical,)
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
% Example:
%   st = scitran('scitran');
%
%  Retrieves toolboxes.json from this project
%   % Default filename is toolboxes.json
%   tbxFile = st.toolbox('project','ALDIT');  

%   % Specify the filename
%   tbxFile = st.toolbox('project','ALDIT','file','yourName.json');
%
%  Returns a toolboxes struct without installing
%   tbxFile = st.search('files','project label','Diffusion Noise Analysis','filename','toolboxes.json')
%   tbx = st.toolbox('file',tbxFile{1},'install',false);
%
%  You can install later using
%   tbx.install; 
%  Or
%   tbx.clone;
%
% See also:  s_tbxSave, @toolboxes
%
% TODO:  If the repository is on the path as a zip download, we return that
% the repository is installed even if the person asked for a git clone
% download.  We should find a test of whether the download is a git clone
% or a zip download.s
%  
% BW, Scitran Team, 2017

%%
p = inputParser;

vFunc = @(x)(isstruct(x) || ischar(x));
p.addParameter('file','toolboxes.json',vFunc);
p.addParameter('project','', @ischar);        % Project label
p.addParameter('install',true, @islogical);   % Install
p.addParameter('clone',false, @islogical);   % Install

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
        fileC = st.search('files',...
            'project label contains',project,...
            'filename',file);
        if length(fileC) ~= 1
            error('Problem identifying JSON toolbox file.  Search returned %d items\n',length(fileC));
        else
            fileS = fileC{1};   % Copy the struct
        end
    end
else
    fileS = file;
end

tbxFile = st.get(fileS);
tbx = tbxRead(tbxFile);

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
    % Assume testing only
    for ii=1:nTbx
        if isempty(which(tbx(ii).testcmd))
            fprintf('<%s> not found. (Repository <%s>)\n',tbx(ii).testcmd,tbx(ii).gitrepo.project);
        else
            fprintf('<%s> found.\n',tbx(ii).testcmd);
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