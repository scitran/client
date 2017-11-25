function [dwi,destination] = dwiLoad(st,acquisitionID,varargin)
% Load nifti, bvec, and bval from a Flywheel acquisition
%
% Syntax
%   dwi = st.dwiLoad(acquisitionID,varargin);
%
% There must be one nifti, bval, and bvec file in the acquisition. These
% three files are downloaded and their values are returned as a dwi struct
% that can be treated as per vistasoft (dwiGet/Set)
%
% Required inputs
%  acquistionID:  Flywheel acquisition id
% 
% Optional inputs:
%  destination:   Directory for saving the nii, bvec, and bval files.  If
%                 no directory is specified, they are written into
%                 scitranClient/local. 
%
% See also: s_stDiffusion.m, s_stALDIT.m
%
% BW Scitran Team, 2017

%{
 % Example:
 project = 'ALDIT';
 session = 'Set 3';
 acquisitions = st.search('acquisition', ...
            'project label exact',project,...
            'session label exact',session,...
            'acquisition label contains','1000');
 dwi = st.dwiLoad(acquisitions{1}.acquisition.x_id);
%}


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
    'file type','bvec');
if length(bvecFile) > 1, warning('Multiple bvec files.  Returning 1st'); end
bvecName = fullfile(destination,bvecFile{1}.file.name);
st.downloadFile(bvecFile{1},'destination',bvecName);

bvalFile = st.search('files',...
    'acquisition id',acquisitionID,...
    'file type','bval');
if length(bvalFile) > 1, warning('Multiple bval files.  Returning 1st'); end
bvalName = fullfile(destination,bvalFile{1}.file.name);
st.downloadFile(bvalFile{1},'destination',bvalName);

niiFile = st.search('files',...
    'acquisition id',acquisitionID,...
    'file type','nifti');
if length(niiFile) > 1, warning('Multiple nii files.  Returning 1st'); end
niiName = fullfile(destination,niiFile{1}.file.name);
st.downloadFile(niiFile{1},'destination',niiName);

%% Read and return

dwi = dwiLoad(niiName, bvecName,bvalName);

%% Add option to delete after download?

end

