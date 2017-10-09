%% Download a diffusion set (dwi, bvec, bval)
%
%  Find a diffusion data set in an acquisition and return the dwi, bvec,
%  and bval files
%

%%
fw = scitran('vistalab');

%%  Find acquisitions from SVIP Release with dti 30 direction data

acq = fw.search('acquisitions',...
    'project label contains','SVIP Released',...
    'acquisition label exact','DTI_30dir',...
    'summary',true);
    
fprintf('Found %d acquisitions\n',length(acq));

%%  Run the dwiLoad on one of the acquistions

% dwi is a structure with the data and the filenames
dwi = fw.dwiLoad(acq{1}.acquisition.x_id);

%% Try another one

dwi = fw.dwiLoad(acq{5}.acquisition.x_id);

%% Find the list of session labels for these acquisitions

sessionlabels = cell(length(acq),1);
for ii=1:length(acq)
    sessionlabels{ii} = acq{ii}.session.label;
end

% Find the unique session labels.  ListB contains an index into the
% session that contains each of the acquisitions.
[uniqueLabels,ListA,ListB] = unique(sessionlabels);

% These are the acquisitions that are in session idx.  Out of the first
% 100, we have one example of two acquisitions.  Not sure why.
for jj=1:length(uniqueLabels)
    idx = find(ListB == jj);
    if length(idx) > 1
        fprintf('Session %s subject code %s has %d DTI_30dir acquistions\n',acq{idx(1)}.session.label,acq{idx(1)}.subject.code,length(idx));
        %     for ii=1:length(idx)
        %         acq{idx(ii)}.session.label
        %     end
    end
end

%%
    
