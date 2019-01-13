function result = analysisDownload(st,analysis,varargin)
% Return the flywheel.model.Analysis container
%
% Syntax
%   result = scitran.analysisDownload(analysis, ...)
%
% Description
%  Download either the analysis object metadata or a file from the
%  analysis. 
%
%  As an example, you might search for the analysis.  The search return
%  does not have all the information. You can get the full information by
%  calling analysisDownload with the search return
%
%      analysisSearch = st.search(... analysis ...);
%      analysis = st.analysisDownload(analysisSearch);
%
% Required Inputs
%  analysis    - A Flywheel analysis object or a string specifying just the
%                id. The analysis object can be a search return or the
%                an analysis object via fw.getAnalysis.
%
% Optional key/value parameters
%  inputfile   - Name of the analysis input file
%  outputfile  - Name of the analysis output file
%  destination - full path to file output location
%
% Return
%  result - Either an analysis object or the full path to downloaded file.
%
% LMP/BW Vistasoft Team, 2015-16
%
% See also: 
%   s_stDownloadContainer, s_stDownloadFile, scitran.search

%% Download the whole analysis as a tar file is supposed to become possible.
%  Also, remember FlywheelExamples.m
%  Also, Justin E has a major upgrade in the works involving methods
%  attached to objects (e.g. session.downloadDown) as part of the SDK 2.0.

% Examples:
%{
  st = scitran('stanfordlabs');

  % The search return for the analysis does not get the whole analysis,
  % It gets a lot of information.  But to keep search fast, they return a
  % SearchAnalysisResponse, rather than
  analysisSearch = st.search('analysis',...
    'project label exact','Brain Beats',...
    'session label exact','20180319_1232');

  % Gets the container, which has the input and output files
  analysis = st.analysisDownload(id);

  % Maybe you already know the input file names
  id = st.objectParse(analysisSearch{1});
  st.analysisDownload(id,...
    'inputfile',d.inputs{1}.name,...
    'destination','deleteme.nii.gz');
  
  % Gets the output file
  st.analysisDownload(analysis,...
    'outputfile',analysis.files{1}.name,...
    'destination','deleteme.mat');
%}

%% Parse inputs
p = inputParser;
varargin = stParamFormat(varargin);

p.addRequired('analysis', ...
    @(x)(ischar(x) || ...
    isa(x,'flywheel.model.AnalysisOutput')));

p.addParameter('inputfile','',@ischar);
p.addParameter('outputfile','',@ischar);
p.addParameter('destination','',@ischar);

p.parse(analysis,varargin{:});
inputfile   = p.Results.inputfile;
destination = p.Results.destination;
outputfile  = p.Results.outputfile;

% If a string that should be the id.  Otherwise it should be a
% flywheel.model.AnalysisOutput.  See examples above.
if     ischar(analysis),        id = analysis;
elseif isa(analysis,'flywheel.model.AnalysisOutput'), id = analysis.id;
end

%% Download either the analysis object or a file.

% We could search the analysis filenames to determine if this is an
% input or output side file.  But for now, we make the user specify.

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


