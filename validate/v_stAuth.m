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
st = scitran('action','create','instance','scitran');

% The token is a long, obscure string
disp(st)

%% If you have lost the token by a matlab clear you might run
 
st = scitran('action','refresh','instance','scitran');

% If result returns 0, then we are good
disp(st)


%% Remove the token

st = scitran('action','remove','instance','scitran');

% If result returns 0, then we are good
disp(st)

%% Recreate

st = scitran('action','create','instance','scitran');

disp(st)
%%