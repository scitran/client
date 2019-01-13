function [dwi,destination] = dwiDownload(st,acquisitionID,varargin)
% Load nifti, bvec, and bval from a Flywheel acquisition
%
% Syntax
%   dwi = st.dwiDownload(acquisitionID,varargin);
%
% There must be one nifti, bval, and bvec file in the acquisition. These
% three files are downloaded and their values are returned as a dwi struct
% that can be treated as per vistasoft (dwiGet/Set)
%
% Required inputs
%  acquistionID:  Flywheel acquisition id
% 
% Optional key/value pairs
%  verbose:       Logical
%  destination:   Directory for saving the nii, bvec, and bval files.  If
%                 no directory is specified, they are written into
%                 scitranClient/local. 
%
% Return
%  dwi:  A struct containg the data
%  destination:  Location on local disk where the data are stored
%
% BW Scitran Team, 2017
%
% See also:
% s_stDiffusion.m, s_stALDIT.m

% Examples:
%{
 project = 'ALDIT';
 session = 'Set 3';
 acquisitions = st.search('acquisition', ...
            'project label exact',project,...
            'session label exact',session,...
            'acquisition label contains','1000');
id  = st.objectParse(acquisitions{1});
[dwi, destination] = st.dwiDownload(id,'verbose',true);
%}


%% Parse
p = inputParser;
p.addRequired('acquisitionID',@ischar);
p.addParameter('destination',fullfile(stRootPath,'local'),@ischar);
p.addParameter('verbose',false,@islogical);

p.parse(acquisitionID,varargin{:});

verbose     = p.Results.verbose;
destination = p.Results.destination;
if ~exist(destination,'dir'), mkdir(destination); end

%% Search and download

% We always return the 1st, but we print a summary to says how many are
% found.
bvecFile = st.search('files',...
    'acquisition id',acquisitionID,...
    'file type','bvec');
if length(bvecFile) ~= 1
    error('%d bvec files found',length(bvecFile));
end
bvecName = fullfile(destination,bvecFile{1}.file.name);
if verbose, disp('bvec download'); end
st.fileDownload(bvecFile{1},'destination',bvecName);

bvalFile = st.search('files',...
    'acquisition id',acquisitionID,...
    'file type','bval');
if length(bvecFile) ~= 1
    error('%d bval files found',length(bvalFile));
end
if verbose, disp('bval download'); end
bvalName = fullfile(destination,bvalFile{1}.file.name);
st.fileDownload(bvalFile{1},'destination',bvalName);

niiFile = st.search('files',...
    'acquisition id',acquisitionID,...
    'file type','nifti');
if length(niiFile) > 1, warning('Multiple nii files.  Returning 1st'); end
niiName = fullfile(destination,niiFile{1}.file.name);

if verbose, disp('nifti download'); end
st.fileDownload(niiFile{1},'destination',niiName);

%% Try to read and return.  dwiLoad is a vistasoft routine
try
    dwi = dwiLoad(niiName, bvecName,bvalName);
catch
    dwi = destination;
    fprintf('Data downloaded to %s, but no dwiLoad found.',destination);
end

%% Add option to delete after download?

end

