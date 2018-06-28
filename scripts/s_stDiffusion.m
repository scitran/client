%% Download a diffusion set (dwi, bvec, bval)
%
%  Find a diffusion data set in an acquisition and return the dwi, bvec,
%  and bval files
%

%%
st = scitran('stanfordlabs');

%%  Find acquisitions from SVIP Release with dti 30 direction data

acq = st.search('acquisitions',...
    'project label contains','SVIP Released',...
    'acquisition label exact','DTI_30dir',...
    'summary',true);
    
fprintf('Found %d acquisitions\n',length(acq));

%%  Run the dwiLoad on one of the acquistions

% dwi is a structure with the data and the filenames
dwi = st.dwiLoad(idGet(acq{1}));

%% Try another one

dwi = st.dwiLoad(idGet(acq{5}));

%%
    
