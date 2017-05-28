function dwi = dwiLoad(st,acquisitionID,varargin)
% Load nifti, bvec, and bval from a flywheel acquisition
%
%      dwi = st.dwiLoad(acquisitionID,varargin);
% Or,  dwi = dwiLoad(st,acquisitionID,varargin);
%
% We assume that there is one nifti, bval, and bvec file in the
% acquisition.  These are downloaded and returned as a dwi struct that can
% as per vistasoft (dwiGet/Set)
%
% Required inputs
%  st:            A scitran object
%  acquistionID:  Flywheel acquisition
% 
% Optional inputs:
%  destination:   Directory for saving the three files.  If no directory is
%                 specified, they are written into scitranClient/local.
%
% Example:
%   See s_stALDIT.m
%
% BW Scitran Team, 2017

%% Parse
p = inputParser;
p.addRequired('acquisitionID',@ischar);
p.addParameter('destination',fullfile(stRootPath,'local'),@ischar);
p.parse(acquisitionID,varargin{:});
destination = p.Results.destination;
if ~exist(destination,'dir'), mkdir(destination); end

%% Search and download

% We always return the 1st, but we print a summary to says how many are
% found.
bvecFile = st.search('files',...
    'acquisition id',acquisitionID,...
    'file type','bvec', ...
    'summary',true);
st.get(bvecFile{1},'destination',fullfile(destination,'dmri.bvec'));

bvalFile = st.search('files',...
    'acquisition id',acquisitionID,...
    'file type','bval',...
    'summary',true);
st.get(bvalFile{1},'destination',fullfile(destination,'dmri.bval'));

niiFile = st.search('files',...
    'acquisition id',acquisitionID,...
    'file type','nifti',...
    'summary',true);
st.get(niiFile{1},'destination',fullfile(destination,'dmri.nii.gz'));

%% Read and return
dwi = dwiLoad(fullfile(destination,'dmri.nii.gz'));

end

