function [result, srchFile, esCMD] = search(obj,srch,varargin)
% Create an elastic search cmd and run it with curl
%
%  [srchResult, srchFile, esCMD] = st.search(srch, ...)
%
% Input:
%  srch:  A struct or a string
%     If a struct, then the fields needed to create the search command
%     If a string, then the search return and we build the struct from the
%     varargin{}
%
% Return:
%  result:    Cell array of returned data structs
%  srchFile:  Name of json file returned by the search
%  esCMD:     The elastic search curl command 
%
% Examples:
%   Simple search
%
%   Advanced searches
%
% BW Scitran Team 2016

%% Could check the srch struct here for the appropriate fields
%
p = inputParser;
p.KeepUnmatched = true;

% Could be a string or a struct.  If a string, then we are in the simple
% search case.
p.addRequired('srch');  

% If you want the json file returned by the search, then this should be a
% legitimate file name for writing it.  It should have a .json extension.
% I think we should get rid of this.
p.addParameter('oFile','',@ischar);

% Not sure what this means yet
p.addParameter('all_data',false,@islogical);

p.parse(srch,varargin{:});
srch  = p.Results.srch;
oFile = p.Results.oFile;
all_data = p.Results.all_data;

%% Simple search case.  So we build a Matlab srch structure

% This could become a utility function in a separate file.  It would take
% the searchType and varargin{:}, and return a srch struct.
if ischar(srch)
    
    % Determine the search type
    searchType = srch;
    vFunc = @(x)(ismember(x,{'files','sessions','acquisitions','projects'}));
    if ~vFunc(searchType)
        error('Unknown search return type %s\n',srch);
    end
    
    % Make sure length of varargin is even
    if mod(length(varargin),2)
        error('Must have an even number of param/val varargin');
    end
    
    % Start building the Matlab srch struct
    clear srch
    srch.path = searchType;
    
    % Build the search structure from the param/val pairs
    n = length(varargin);
    for ii=1:2:n
        val = varargin{ii+1};
        
        % Force lower and remove blanks
        sformatted = strrep(lower(varargin{ii}),' ','');
        
        switch stParamFormat(sformatted)
            case 'sessionlabel'
                srch.sessions.match.label = val;
            case 'sessionid'
                srch.sessions.match.x0x5F_id = val;
            case {'projectlabel','project'}
                srch.projects.match.label = val;
            case {'acquisitionlabelcontains'}
                srch.acquisitions.match.label = val;
            case {'acquisitionlabelexact','acquisitionlabel'}
                srch.acquisitions.match.exact_label = val;
            case {'filename'}
                srch.files.match.name = val;
            case {'subjectcode'}
                srch.sessions.match.subjectx0x2E_code = val;
            otherwise
        end
        
    end
end

    
%% Convert the Matlab struct is converted to json here.  

srch = jsonwrite(srch,struct('indent','  ','replacementstyle','hex'));
srch = regexprep(srch, '\n|\t', ' ');
srch = regexprep(srch, ' *', ' ');
esCMD = obj.searchCmd(srch,'all_data',all_data);


%% Run the elastic search curl command

% result is a string with a bunch of stuff RF put in it, including timing
% information and the json output file.  We get the filename below.
[~, result] = system(esCMD);

%% Clean up the result

% Load the result json file. NOTE the use of strtrim to get rid of the
% final blank character
if ismac
    srchFile = strtrim(result(strfind(result,'/private/tmp'):end));
elseif isunix
    srchFile = strtrim(result(strfind(result,'/tmp'):end));
end

% This is now a Matlab struct with a lot of ugly terms.  We clean them up
% below.
if ~exist(srchFile,'file'), error('Results does not contain a valid search file');
else
    % disp('Running jsonread on returned file');
    %    tic
    % srchResult = loadjson(srchFile);
    srchResult = jsonread(srchFile);
    %   toc
end

if isfield(srchResult,'message')
    result = srchResult;
    fprintf('Search error\n');
    fprintf('Status code: %d\n',result.status_code);
    fprintf('Message:     %s\n',result.message);
    return;
end

% Sometimes the result is empty.  Typically it is a struct.
result = stParseSearch(obj,srchResult);

% Leave the search file, or if it is not asked for delete it.
if nargout == 1,  delete(srchFile); end

end
