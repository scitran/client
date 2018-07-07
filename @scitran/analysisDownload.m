function destination = analysisDownload(obj,id,fname,varargin)
% Return an output file from a Flywheel analysis
%
% Syntax
%   destination = scitran.analysisDownload(id, fname, ...)
%
% Description
%  Words about analyses
%
% Required Inputs
%  id    - The Flywheel analysis ID
%  fname - Name of the analysis output file
%
% Optional key/value parameters
%  destination - full path to file output location
%
% Return
%  destination:  Full path to the file object on disk
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
  fprintf('Downloaded %s\n',d);
%}

%%
%{
% This bug worries me.

% This session has an analysis.  But it is not returned in the search info
session = st.search('session',...
   'project label exact','Brain Beats',...
   'session label exact','20180319_1232');

% The analysis slot is empty
session{1}.analysis

% This is the session id
idGet(session{1},'session')

% Yet, this session has an analysis which we find when we do a search.
analysis = st.search('analysis',...
   'project label exact','Brain Beats',...
   'session label exact','20180319_1232');

% Notice that the analysis is attached to the right session id
analysis{1}.session.id
session{1}.session.id
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
