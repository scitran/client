function tbx = toolbox(st,varargin)
% Install toolboxes from github repositories.
%
%    tbx = st.toolbox(tbxFileStruct,'install',logical)
%
% Input parameters
%   project:  The project label
%   tbxFile:  This is either a struct defining the toolbox JSON file on the
%             scitran site (returned by a search), or it is simply the 
%             name of the JSON toolbox file in the project (default is
%             'toolboxes.json'). 
%   install:  Boolean on whether to execute toolboxes.install (default: true)
%   clone:    Boolean (default is false, which means download zip)
%
% Output
%   tbx - the toolboxes object
%
% Example:
%   st = scitran('scitran');
%
%  Retrieves toolboxes.json from this project
%   % Default filename is toolboxes.json
%   tbxFile = st.toolbox('project','Diffusion Noise Analysis');  

%   % Specify the filename
%   tbxFile = st.toolbox('project','Diffusion Noise Analysis','file','yourName.json');
%
%  Returns a toolboxes struct without installing
%   tbxFile = st.search('files','project label','Diffusion Noise Analysis','filename','toolboxes.json')
%   tbx = st.toolbox('file',tbxFile{1},'install',false);
%
%  You can install later using
%   tbx.install;
%
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

% Get the struct for the file information.
if ischar(file)
    if isempty(project)
        error('Project label required when file is a string');
    else
        %  Get the file information, which is a cell array
        fileC = st.search('files',...
            'project label',project,...
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

% Build a toolbox structure that contains the information necessary for an
% install.  This is returned.
tbx = toolboxes('scitran',st,'file',fileS);

%% Do or don't install, using the toolboxes object install method

% If we install, the toolbox object checks if the path already contains the
% test function.  If not, then it installs from the github repository
% specified in the toolbox file structure.  
%
% Originally, we installed using git clone.  But going forward, we will
% probably create a tmp directory, download the zip file for each
% repository, and unzip them all into the tmp directory.  We will then add
% the tmp directory to the user's path.

if install && clone,     tbx.clone;
elseif install,          tbx.install; 
end

end

%% 