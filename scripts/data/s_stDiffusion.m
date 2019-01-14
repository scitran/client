%% Download a diffusion set (dwi, bvec, bval)
%
%  Illustrate downloading a diffusion data set in an acquisition and return
%  the dwi, bvec, and bval files.  The nice thing about this example is it
%  calls dwiLoad to get all of the data in one call.
%
% BW, Vistasoft team, 2018

%%
st = scitran('stanfordlabs');

%%  Find acquisitions from SVIP Release with dti 30 direction data
p = st.search('projects','fw',false);
stPrint(p,'project','label')

acq = st.search('project',...
    'project label contains','SVIP',...
    'limit',3, ...
    'fw',true);

acq = st.search('project',...
    'project label contains','SVIP Released',...
    'limit',1);

    'summary',true);
    
fprintf('Found %d acquisitions\n',length(acq));

%%  Run the dwiLoad on one of the acquistions

% dwi is a structure with the data and the filenames
dwi = st.dwiDownload(idGet(acq{1},'data type','acquisition'));

%% Show the user the story
disp(dwi)

%%
    
