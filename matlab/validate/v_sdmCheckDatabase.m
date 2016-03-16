%% Check that the database is running on this system
%
% 1.  It is running
% 2.  You can get an authorization token
%
% LMP/BW Scitran Team, 2016

%% Check that the database is up

% This needs to be your specific instance
url = 'https://docker.local.flywheel.io:8443';
% url = 'https://cni.stanford.edu'

cmd = sprintf('curl -Is -k %s | grep HTTP | cut -d '' '' -f2', url);
% cmd = sprintf('curl -Is %s', url)

[status, result] = system(cmd);

if strcmp(result,'200') % then we're good
    fprintf('Flywheel site detected at url %s\n',url);
else
    fprintf('Flywheel site not found\nurl tested:  %s\n',url);
end

    
%% Authorization

%  Get a token that shows you can use this
%  Something like this:
%
%     token = sdmAuth('create',url);
%

%%
