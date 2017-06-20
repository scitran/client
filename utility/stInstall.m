function thisDir = stInstall
% Deprecated
% See installScitran
%
% Clones the scitran/jsonio directories and adds them to your path
% 
%   stInstall;
%
% BW/LMP Scitran Team, 2017

thisDir = pwd;

status = system('git clone https://github.com/scitran/client');
if status, error('Problem cloning the scitran client repository'); end
movefile('client','scitranClient');

status = system('git clone https://github.com/gllmflndn/JSONio');
if status, error('Problem cloning the JSONio repository'); end

chdir('scitranClient'); addpath(genpath(pwd));
chdir(thisDir); chdir('JSONio'); addpath(genpath(pwd));

chdir(thisDir);

% Tell user where they are
fprintf('\n\nThe scitranClient and JSONio toolboxes are in\n---\n \t %s\n---\n',thisDir);

end

%% First time

% st = scitran('newInstance','action', 'create')