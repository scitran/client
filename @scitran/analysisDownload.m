function result = analysisDownload(st,id,varargin)
% Return the flywheel.model.Analysis container
%
% Syntax
%   result = scitran.analysisDownload(id, ...)
%
% Description
%  Download an analysis object based on its id, or download a file from the
%  analysis.
%
% Required Inputs
%  id    - The Flywheel analysis ID
%
% Optional key/value parameters
%  inputfile   - Name of the analysis input file
%  outputfile  - Name of the analysis output file
%  destination - full path to file output location
%
% Return
%  result - Either and analysis struct or the full path to downloaded file
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
  d = st.analysisDownload(id);

  st.analysisDownload(id,...
    'file name',d.files{1}.name,...
    'in or out','out',...
    'destination','deleteme.mat');

  st.analysisDownload(id,...
    'file name',d.inputs{1}.name,...
    'in or out','in',...
    'destination','deleteme.nii.gz');

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
varargin = stParamFormat(varargin);

p.addRequired('id',@ischar);

p.addParameter('inputfile','',@ischar);
p.addParameter('outputfile','',@ischar);
p.addParameter('destination','',@ischar);

p.parse(id,varargin{:});
inputfile   = p.Results.inputfile;
destination = p.Results.destination;
outputfile  = p.Results.outputfile;

%% If fname is not empty, 

if isempty(inputfile) && isempty(outputfile)
    % Person wants the analysis, not a file from the analysis
    result = st.fw.getAnalysis(id);
    return;
elseif ~isempty(inputfile) && ~isempty(outputfile)
        error('We cannot download both an input and an output file at this time');
else
    % User wants an input or output file from the analysis. 
    if isempty(inputfile), fname = outputfile;
    else, fname = inputfile;
    end
    
    % Make sure the file destination is a full path.  This could be a
    % function.  Also, should we use pwd or tempdir?
    if ~isempty(destination)
        % Make sure destination is a full path
        thisSlash = fullfile(pwd);
        if ~isequal(destination(1),thisSlash(1))
            destination = fullfile(pwd,destination);
        end
    else
        [~,n,e] = fileparts(fname);
        destination = fullfile(pwd,[n,e]);
    end
    
    % We could download the analysis and search the filenames to determine
    % if this is an input or output side file.
    if ~isempty(inputfile)
        st.fw.downloadInputFromAnalysis(id, fname, destination);
    elseif ~isempty(outputfile)
        st.fw.downloadOutputFromAnalysis(id, fname, destination);
    else
        warning('No input or output file names found');
    end
    result = destination;
end

end


