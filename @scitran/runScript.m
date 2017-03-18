function execFileName = runScript(stClient,functionName,varargin)
% Search, download, and run a function stored as an attachment at Flywheel
%
% The functionName should be stored on the Flywheel instance, and it
% should conform to specifications that we (will) write.
%
% Required inputs: 
%   functionName - Filename of the script 
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
% Examples:
%   stClient = scitran('action', 'create', 'instance', 'scitran');
%
%  params needs to be set.  See fw_Apricot6.m header
%   stClient.runScript('fw_Apricot6.m','params',params)
%   stClient.runScript('fw_Apricot6.m','destinationDir',fullfile(stRootPath,'local'),'params',params);
%   eFile = stClient.runScript('fw_Apricot6.m','doRun',false,'params',params);
%
% The script you execute should comply with the specifications in
%    ** In which our heros write some specifications **
%
% BW/RF

%%
p = inputParser;
p.addRequired('functionName');

% Specify a directory that will be used as the folder for the script.  The
% default is a random name in the tmp dir for this system.
p.addParameter('destinationDir',tempname,@ischar);
p.addParameter('doRun',true,@islogical);

p.addParameter('sessionid',[],@ischar);
p.addParameter('projectid',[],@ischar);

p.addParameter('params',[],@isstruct);

p.parse(functionName,varargin{:});

destinationDir = p.Results.destinationDir;
doRun          = p.Results.doRun;
params         = p.Results.params; %#ok<NASGU>

%% See if function exists;  if not, search and download it

execFileName = which(functionName);
if isempty(execFileName)
    
    % Set up the search variable.  It always returns a single file
    clear srch
    srch.path = 'files';
    
    % For testing use
    srch.files.match.name = functionName;
    
    % Put in the session and project ids here, when we are ready
    
    % Do the search for the matlab function
    files = stClient.search(srch);
    if numel(files) ~= 1
        error('Wrong number of files returned: %d\n',numel(files));
    end
    
    % Get the function
    if ~exist(destinationDir,'dir'), mkdir(destinationDir); end
    execFileName = stClient.get(files{1},'destination',fullfile(destinationDir,functionName));
    
else
    fprintf('** Planning to execute function %s\n',execFileName);
end

%% Update github repos, check path


%% Execute the script (locally)
[p,n] = fileparts(execFileName);
if doRun
    chdir(p);
    cmd = sprintf('%s(stClient,params);',n);
    fprintf('Executing %s\n',which(n));
    eval(cmd);
    % run(execFileName); 
end

end
%%




