%% s_stInfoCreate
%
% This script illustrates how 
%
% Many of the QA scans have a json description.  We are going to
% download, read the json into a struct, pull out the fields we want
% and set the info file attached to the info for the JSON file itself
% and the <>qa.png files.  They each have relevant numbers we want to
% be able to read.
%
%
% LMP/BW Vistalab, 2017

%% Authorization

st = scitran('stanfordlabs');
st.verify;

%% The qa project has many acquisitions with a type files in them

% There is a bug here.  Unless we specify 'filetype,'qa', the
% montage.zip file is returned.  This is an error.

% We could get a list of the acquisitions and sessions using
% list, but for now we are experimenting with just one.
files = st.search('file',...
    'project label exact','qa',...
    'session label exact','16542',...
    'acquisition label exact','16542_4_1_BOLD_EPI_Ax_AP',...
    'filename contains','json',...
    'filetype','qa',...
    'summary',true);

%% Download the json file
destination = st.downloadFile(files{1});
qaInfo = jsonread(destination);

%% Now, extract the fields we want for the json info data 

jsonInfoFields = {'temporalSNR_median_','medianMd','spikes',...
    'maxMd','tr','version','spikeThresh'};
for ii=1:length(jsonInfoFields)
    jsonInfo.(jsonInfoFields{ii}) = qaInfo.(jsonInfoFields{ii});
end
jsonInfo.numSpikes = numel(qaInfo.spikes);

%% Attach it to the JSON file

st.setFileInfo(files{1},jsonInfo);

% fname = files{1}.file.name;
% parentID = files{1}.parent.x_id;
% st.fw.setAcquisitionFileInfo(parentID,fname,jsonInfo);

%% Attach the same information on the png file

files = st.search('file',...
    'project label exact','qa',...
    'session label exact','16542',...
    'acquisition label exact','16542_3_1_BOLD_EPI_Ax_RL',...
    'filename contains','png',...
    'filetype','qa',...
    'summary',true);
fname = files{1}.file.name;
st.fw.setAcquisitionFileInfo(parentID,fname,jsonInfo);

%%