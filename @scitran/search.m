function [result, srchFile, esCMD] = search(obj,srch,varargin)
% Create an elastic search cmd and run it with curl
%
%  [srchResult, srchFile, esCMD] = st.search(srch, ...)
%
% Input:
%  srch:  A struct or a string
%     If a struct, then the fields needed to create the search command
%     If a string, then the search return and we build the struct from the
%  all_data: Searchh through all the data, not just the data you own
%
%  varargin{} - pairs of search/value
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

% Not sure what this means yet
p.addParameter('all_data',false,@islogical);

% Remove the spaces from the varargin because the parser complains.  Why
% does it do that?
for ii=1:2:length(varargin)
    varargin{ii} = strrep(lower(varargin{ii}),' ','');
end
p.parse(srch,varargin{:});

srch  = p.Results.srch;
all_data = p.Results.all_data;

%% Simple search case.  So we build a Matlab srch structure

% This could become a utility function in a separate file.  It would take
% the searchType and varargin{:}, and return a srch struct.
if ischar(srch)
    
    % Determine the search type
    vFunc = @(x)(ismember(x,{...
        'files','sessions','acquisitions','projects','collections','analyses', ...
        'filesinanalysis',...
        'filesincollection','acquisitionsincollection','sessionsincollection',...
        'analysesincollection','analysesinsession',...
        }));
    searchType = srch;
    if ~vFunc(strrep(lower(searchType),' ',''))
        error('Unknown search return type %s\n',searchType);
    end
    
    % Make sure length of varargin is even
    if mod(length(varargin),2)
        error('Must have an even number of param/val varargin');
    end
    
    % Start building the Matlab srch struct
    clear srch
    srch.path = searchType;
    switch strrep(lower(searchType),' ','')
        case 'filesinanalysis'
            srch.path = 'analyses/files';
        case 'filesincollection'
            srch.path = 'collections/files';
        case 'acquisitionsincollection'
            srch.path = 'collections/acquisitions';
        case 'sessionsincollection'
            srch.path = 'collections/sessions';
        case 'analysesincollection'
            srch.path = 'collections/analyses';
        case 'analysesinsession'
            srch.path = 'sessions/analyses';
        otherwise
    end
    
    
    % Build the search structure from the param/val pairs
    n = length(varargin);
    for ii=1:2:n
        
        val = varargin{ii+1};
        
        switch stParamFormat(varargin{ii})
            case {'all_data'}
                all_data = val;
                
            case {'sessionlabelcontains'}
                % srch.sessions.match.label = val;
                if ~isfield(srch,'sessions')
                    srch.sessions.bool.must{1}.match.label = val;
                else
                    srch.sessions.bool.must{end + 1}.match.label = val;
                end
            case {'sessionlabelexact','sessionlabel'}
                %srch.sessions.match.exact_label = val;
                if ~isfield(srch,'sessions')
                    srch.sessions.bool.must{1}.match.exact_label = val;
                else
                    srch.sessions.bool.must{end + 1}.match.exact_label = val;
                end
                
            case 'sessionid'
                if ~isfield(srch,'sessions')
                    srch.sessions.bool.must{1}.match.x0x5F_id = val;
                else
                    srch.sessions.bool.must{end + 1}.match.x0x5F_id = val;
                end
            case {'sessionaftertime'}
                
                if ~isfield(srch,'sessions')
                    srch.sessions.bool.must{1}.range.created.gte = val;
                else
                    srch.sessions.bool.must{end + 1}.range.created.gte = val;
                end
            case {'sessionbeforetime'}
                
                if ~isfield(srch,'sessions')
                    srch.sessions.bool.must{1}.range.created.lte = val;
                else
                    srch.sessions.bool.must{end + 1}.range.created.lte = val;
                end
                
            case {'projectlabelcontains'}
                if ~isfield(srch,'project')
                    srch.projects.bool.must{1}.match.label = val;
                else
                    srch.projects.bool.must{end + 1}.match.label = val;
                end
                
                srch.projects.match.label = val;
            case {'projectlabelexact','projectlabel'}
                srch.projects.match.exact_label = val;
            case {'projectid'}
                % Note the ugly x0x5F, needed for jsonio
                srch.projects.match.x0x5F_id = val;   
                
            case {'collectionlabelcontains'}
                srch.collections.match.label = val;
            case {'collectionlabelexact','collectionlabel'}
                srch.collections.match.exact_label = val;


            case {'acquisitionlabelcontains'}
                srch.acquisitions.match.label = val;
            case {'acquisitionlabelexact','acquisitionlabel'}
                srch.acquisitions.match.exact_label = val;
                
            case {'filenamecontains'}
                srch.files.match.name = val;
            case {'filenameexact','filename'}
                srch.files.match.exact_name = val;
            case {'filetype'}
                srch.files.match.type = val;

            case {'subjectcode'}
                srch.sessions.match.subjectx0x2E_code = val;
            case {'subjectagegt'}
                % Subject age greater than
                if ~isfield(srch,'sessions')
                    srch.sessions.bool.must{1}.range.subjectx0x2E_age.gt= val;
                else
                    srch.sessions.bool.must{end + 1}.range.subjectx0x2E_age.gt = val;
                end
                
            case {'subjectagelt'}
                % Subject age less than
                if ~isfield(srch,'sessions')
                    srch.sessions.bool.must{1}.range.subjectx0x2E_age.lt= val;
                else
                    srch.sessions.bool.must{end + 1}.range.subjectx0x2E_age.lt = val;
                end
                
            case {'analysislabelexact','analysislabel'}
                srch.analysis.match.exact_label = val;
            case {'analysislabelcontains'}
                srch.analysis.match.label = val;
                                
            otherwise
                error('Unknown search variable %s\n',varargin{ii});
        end
        
    end
end

%% Convert the Matlab struct to json text

srch = jsonwrite(srch,struct('indent','  ','replacementstyle','hex'));
srch = regexprep(srch, '\n|\t', ' ');
srch = regexprep(srch, ' *', ' ');

% The all_data flag ... what does it do?
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

%% If the search file is not returned, delete it
if nargout == 1,  delete(srchFile); end

end
