%% Check that the database is running 
%
% LMP/BW Scitran Team, 2016

%% Check that the database is up

% This needs to be your specific instance
url = 'https://flywheel.scitran.stanford.edu';
% url = 'https://cni.stanford.edu'

cmd = sprintf('curl -Is -k %s | grep HTTP | cut -d '' '' -f2', url);
% cmd = sprintf('curl -Is %s', url)

[status, result] = system(cmd);
result = strtrim(result);  % Strip space

% Result has a blank in it somewhere
if strfind(result,'200') % then we're good
    fprintf('Flywheel site detected at url %s\n',url);
else
    fprintf('Flywheel site not found\nurl tested:  %s\n',url);
end


%%
