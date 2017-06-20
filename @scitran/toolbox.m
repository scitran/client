function tbx = toolbox(st,varargin)
% Install toolboxes for a script or function in a scitran instance
%
%    tbx = st.toolbox(fileStruct,'install',logical)
%
% Input parameters
%   project:  The project label
%   file:     This is either a struct defining the toolbox JSON or the name
%             of the JSON toolbox file (default 'toolboxes.json').
%   install:  Boolean on whether to execute toolboxes.install (default: true)
%
% Output
%   tbx - the toolboxes object
%
% Example:
%   st = scitran('scitran','action', 'create');
%
%  Retrieves toolboxes.json from this project
%   tbxFile = st.toolbox('project','Diffusion Noise Analysis');
%   tbxFile = st.toolbox('project','Diffusion Noise Analysis','file','yourName.json');
%
%  Returns a toolboxes struct without installing
%   tbxFile = st.search('files','project label','Diffusion Noise Analysis','filename','toolboxes.json')
%   tbx = st.toolbox('file',tbxFile{1},'install',false);
%
%  
% BW, Scitran Team, 2017

%%
p = inputParser;

vFunc = @(x)(isstruct(x) || ischar(x));
p.addParameter('file','toolboxes.json',vFunc);
p.addParameter('project','', @ischar);    % Project label
p.addParameter('install',true, @islogical);

p.parse(varargin{:});

project = p.Results.project;
file    = p.Results.file;
install = p.Results.install;

%% Set up the toolboxes object

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

tbx = toolboxes('scitran',st,'file',fileS);

%% Do or don't install

if install, tbx.install; end

end

%% 