function [destination, thisAnalysis] = analysisDownload(obj,id,varargin)
% Return the flywheel.model.Analysis container
%
% Syntax
%   thisAnalysis = scitran.analysisDownload(id, ...)
%
% Description
%  Not sure whether there is a way to get the whole analysis down with a
%  ticket or what.
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
  id = idGet(analysis{1},'data type','analysis');
  d = st.analysisDownload(id,'rh.white.obj');
  fprintf('Downloaded %s\n',d);
%}

%%

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
p = inputParser;
p.addRequired('id',@ischar);

% This is what needs to come on down.  Not sure whether there is an API for
% this or we need to loop.
thisAnalysis = obj.fw.getAnalysis(id);
thisAnalysis.inputs
thisAnalysis.files

% destination = fullfile(stRootPath,'local',fname);

disp('analysis download NYI')

end


%{
varargin = stParamFormat(varargin);


p.addRequired('fname',@ischar);
p.parse(id,fname,varargin{:});

%% Download a file from analysis

destination = obj.fw.downloadOutputFromAnalysis(id, fname, destination);

end
%}

