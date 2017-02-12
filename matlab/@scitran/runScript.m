function execFileName = runScript(stClient,scriptName,varargin)
% Search, download, and run a script stored as an attachment at Flywheel
%
% The scriptName should be stored on the Flywheel instance,k and it should
% conform to specifications that we (will) write.  
%
% Required inputs: 
%   scriptName - Filename of the script 
%
% Optional inputs (to help find the script)
%   destinationDir - Directory to place the scriptName
%   projectid  - Specify search parameter srch.project.match.name
%   sessionid  - Specify search parameter srch.session.match.name
%   doRun      - Boolean specifying whether to execute or not (default = true)
%
% Return:
%   execFileName   - Full path to the local copy of the script name  
%
% Example
%  stClient = scitran('action', 'create', 'instance', 'scitran');
%  stClient.runScript('fw_Apricot6.m')
%  stClient.runScript('fw_Apricot6.m','destinationDir',fullfile(stRootPath,'local'))
%  eFile = stClient.runScript('fw_Apricot6.m','doRun',false)
%
% The script you execute should comply with the specifications in
%    ** In which our heros write some specifications **
%
% BW/RF

%%
p = inputParser;
p.addRequired('scriptName');

% Specify a directory that will be used as the folder for the script.  The
% default is a random name in the tmp dir for this system.
p.addParameter('destinationDir',tempname,@ischar);
p.addParameter('doRun',true,@islogical);

p.addParameter('sessionid',[],@ischar);
p.addParameter('projectid',[],@ischar);

p.parse(scriptName,varargin{:});

destinationDir = p.Results.destinationDir;
doRun = p.Results.doRun;

%% Search and download the script

% Set up the search variable.  It always returns a single file
clear srch
srch.path = 'files';

% For testing use
%   scriptName = 'fw_Apricot6.m'
srch.files.match.name = scriptName;

% Put in the session and project ids here, when we are ready

% Do the search
files = stClient.search(srch);
if numel(files) ~= 1
    error('Wrong number of files returned: %d\n',numel(files));
end

% We need to build the plink for the file.
% We should write a utility to build the permalink for any type of object.
% See stParseSearch where we build some plinks.
% plink = sprintf('%s/api/acquisitions/%s/files/%s', stClient.url, files{1}.source.acquisition.x0x5F_id, files{idx}.source.name);

% This won't run until the Issue is fixed by Renzo for building the
% permalink of a file.
if ~exist(destinationDir,'dir'), mkdir(destinationDir); end
execFileName = stClient.get(files{1},'destination',fullfile(destinationDir,scriptName));

%% Update github repos, check path


%% Execute the script (locally)
if doRun, run(execFileName); end

end
%%




