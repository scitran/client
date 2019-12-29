function fwImportFolder(st,folderpath,varargin)
% Call the CLI to import a folder into a Flywheel project
%
% Syntax
%    scitran.fwImportFolder(folderpath,varargin)
%
% Inputs
%  st - scitran object
%  folderpath - the base folder that contains the FW directory tree
%                 within it.
%
% Optional Key/val pairs
%   cli  - CLI file (default is /usr/local/bin/fw)
%
% Returns
%
% Description
%  TODO: Update to handle various optional flags to the modern CLI.
%
%
% This is the expected layout of the important folder
%{
root-folder
 group-id
    project-label
        subject-label
            session-label
                acquisition-label
                   data.foo
                   scan.nii.gz
%}

% Examples:
%{
   st.fwImportFolder('')
%}

%% Parse

% User help
if isempty(folderpath) || isequal(folderpath,'help')
    fprintf('Help on the CLI commands.');
    system('/usr/local/bin/fw help');
    
    fprintf('\n*** This function only calls "import folder *** ".\n\n');
    system('/usr/local/bin/fw import folder --help');
    
    return;
end

varargin = stParamFormat(varargin);

p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('folderpath',@isdir);

% Use stDockerConfig to set the environment path, if needed
% If the user has fw else where, use this key/val argument
p.addParameter('cli','/usr/local/bin/fw',@isfile);

p.parse(st,folderpath,varargin{:});

cli = p.Results.cli;

%% Here is the whole system command

% Tell the user what version is being run
cmd = sprintf('%s version',cli);
[s,r] = system(cmd);
if s
   error('Something went wrong on the version command');
end
fprintf('\n-----\n%s-----\n',r);

% Main command
cmd = sprintf('%s import folder %s -y --skip-existing',cli,folderpath);
fprintf('\nUsing this command to upload');
fprintf('\n----------')
fprintf('\n   %s',cmd);
fprintf('\n----------\n')

[s,r] = system(cmd);
if s
    warning('Something went wrong');
    fprintf('\n-----\n%s-----\n',r);
else
    fprintf('Status returned OK.  System output: \n')
    fprintf('\n-----\n%s-----\n',r);
end

end

    
