function runScript(stClient,scriptName)
% Search, download, and run a script stored as an attachment at Flywheel
%
%    stClient = scitran('action', 'create', 'instance', 'scitran');
%    stClient.runScript('fw_Apricot6.m')
%
% BW/RF

%%
p = inputParser;
p.addRequired('scriptName');

%% Search and download the script
%
clear srch
srch.path = 'files';
srch.files.match.name = scriptName;  % FOr testing scriptName = 'fw_Apricot6.m'
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
execFileName = stClient.get(files{1});

%% Update any github repos and check path

%% Execute the script
run(execFileName);

%%




