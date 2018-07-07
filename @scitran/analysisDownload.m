function destination = analysisDownload(obj,id,fname,varargin)
% Return an output file from a Flywheel analysis
%
% Syntax
%   destination = scitran.analysisDownload(id, ...)
%
% Description
%  Words about analyses
%
% Required Inputs
%  id  - The Flywheel analysis ID
%  fname - Name of the analysis output file
%
% Optional key/value parameters
%  destination:  full path to file output location
%
% Return
%  thisAnalysis:  Full path to the file object on disk
%
% LMP/BW Vistasoft Team, 2015-16
%
% See also: 
%   s_stDownloadContainer, s_stDownloadFile, scitran.search

% Examples
%{
  st = scitran('stanfordlabs');
  analysis = st.search('analysis',...
   'project label exact','Brain Beats',...
   'session label exact','20180319_1232');
  id = idGet(analysis{1},'analysis');
  d = st.analysisDownload(id,'rh.white.obj');
%}

%%
%{

% I think there is a bug.

% This session has an analysis.  But it is not returned in the search info
session = st.search('session',...
   'project label exact','Brain Beats',...
   'session label exact','20180319_1232');

% Here is the analysis as a search response.
% Its session matches the id above


analysisID = idGet(analysis{1},'analysis')

analysisOutput = st.fw.getAnalysis(analysisID);

% How do w
fname = analysisOutput.files{1}.name
%}
%{

% From FlywheelExample.m
% Have a look at the files
% disp(cellfun(@(f) {f.name}, input_analysis.files))

% Grab the segmented image
% input_file = 'HERO_gka1_aparc.a2009s+aseg.nii.gz';
% dest_path = fullfile('/scratch', input_file);
% fw.downloadOutputFromAnalysis(input_analysis.id, input_file, dest_path);
%}

% We need to figure out how to download the whole analysis as a tar
% file, or individual input and output files. Examples are in
% FlywheelExamples.m

%% Parse inputs
varargin = stParamFormat(varargin);

p = inputParser;
p.addRequired('id',@ischar);
p.addRequired('fname',@ischar);
p.parse(id,fname,varargin{:});

%% Download a file from analysis

destination = fullfile(stRootPath,'local',fname);
destination = obj.fw.downloadOutputFromAnalysis(id, fname, destination);

end

%{

%% Make the flywheel sdk call

thisAnalysis = obj.fw.getAnalysis(id);

end
%}
