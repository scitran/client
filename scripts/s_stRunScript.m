%% s_stRunScript
%
% The script we run is stored in the project as an attachment. The script
% checks that you have the toolboxes and then runs a simple noise analysis
% on the Diffusion Noise project.
%
% BW, Scitran Team, 2017

% Open the client
st = scitran('action', 'create', 'instance', 'scitran');

% Find the script
script = st.search('files',...
    'project label contains','Diffusion Noise',...
    'file name','s_stALDIT.m',...
    'summary',true);

% Run it
st.runScript(script{1});

%%