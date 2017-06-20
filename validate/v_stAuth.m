%% Create (and authorize) a scitran object
%
% See the scitran/client Readme for how to install the relevant python
% libraries and the client secret.
%
% The scitran object includes its url and its secure token.
%
% LMP/BW Scitran Team, 2016

%% Check that the database is up

% It is possible to create, refresh, or revoke
st = scitran('scitran', 'action', 'create');

% The API key is a long, obscure string
disp(st)

%%  Build, refresh, and delete an instance

st = scitran('deleteme','action','create');

st = scitran('deleteme','action','refresh');

st = scitran('deleteme','action','remove');


%%