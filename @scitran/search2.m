function [result, srch] = search2(obj,srch,varargin)
% Create an elastic search cmd and run it with curl
%
%  [srchResult, srch] = st.search(srch, ...)
%
% Required Input:
%  srch:  A struct or a string
%     If a struct, then it must contain all the fields needed to create the
%       search command 
%     If a string, then the search return type, and we build the struct
%       from the parameter/value pairs in varargin.  See s_stSearches.m for
%       many examples.
%
% Return:
%  result:     Cell array of returned data structs
%  srchStruct: The structure defined by the search varargins
%  srchFile:   Name of json file returned by the search
%  esCMD:      The elastic search curl command 
%
% Parameters
%   Many parameter/value pairs are possible to define the search.  
%     * For the common simple search arguments, see the examples in
%       s_stSearches. 
%     * For the general method of constructing advanced searches - see
%       s_stSearchesLongForm.m.
%   In addition to the search parameters, there are two special parameters
%
%     'all_data'   - sets whether to search the entire database, including
%                    projects that you do not have access to (boolean,
%                    default false} 
%     'summary'    - print out a summary of the number of search items
%                    returned (boolean, default false}
%
% Programming Notes
%
%  Matlab uses '.' in structs, and json allows '.' as part of the variable
%  name. So, we insert a dot on the Matlab side by inserting a string,
%  x0x2E in the Matlab variable. We lead with an underscore by using x0x5F
%  at the beginning of the variable. See v_stJSONio for examples or to
%  test.
%
% This information should go on the wiki page, as well.
% 
%   Searching for an object
%
%  Searches begin by defining the type of object you are looking for (e.g.,
%  files).  Then we define the required features of the object.
%
%  We set the terms of the search by  creating a Matlab struct.  The first
%  slot in the struct defines the type of object you are searching for.
%  Suppose we call the struct 'srch'.  The srch.path slot defines the kind
%  of object we are searching for.
%
%   srch.path = 'projects'
%   srch.path = 'sessions'    
%   srch.path = 'acquisitions'
%   srch.path = 'files'        
%   srch.path = 'analysis'
%   srch.path = 'collections'
%
% The search operations are specified by adding additional slots to the
% struct, 'srch'.  These includes specific operators, parameters, and
% values.  The point of this script is to provide many examples of how to
% set up these searches
% 
% Important operators that we use below are
%
%   'match', 'bool', 'must', 'range'
%
% Important parameters we use in search are 
%   'name', 'group', 'label', 'id','plink', subject_0x2E_age',
%   'container_id', 'type'.  
%
% A list of searchable terms can be found in the scitran/core
%
%  <https://github.com/scitran/core/wiki/Data-Model Data Model page>.
%
% Other operators are possible (e.g. 'filtered','filter','query','not') but
% here we illustrate the basics. 
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
p.addParameter('summary',false,@islogical);

% Remove the spaces from the varargin because the parser complains.  Why
% does it do that?
for ii=1:2:length(varargin)
    varargin{ii} = strrep(lower(varargin{ii}),' ','');
end
p.parse(srch,varargin{:});

srch  = p.Results.srch;
all_data = p.Results.all_data;
summary = p.Results.summary;

%% Simple search case.  So we build a Matlab srch structure

% This could become a utility function in a separate file.  It would take
% the searchType and varargin{:}, and return a srch struct.
if ischar(srch)
    
    % Determine the search type
    % Not sure about filesinanalysis or fileinanalysis ...
    vFunc = @(x)(ismember(x,{...
        'file','session','acquisition','project','collection','analysis'
        }));
    searchType = srch;
    if ~vFunc(strrep(lower(searchType),' ',''))
        error('Unknown search return type %s\n',searchType);
    end
    
    % Make sure length of varargin is even
    if mod(length(varargin),2)
        error('Must have an even number of param/val varargin');
    end
    
    clear srch
    srch.return_type = searchType;
    
    % Start building the Matlab srch struct
    % We are doing away with file in mumble at this point, just using the
    % filters{ii}.match.collection0x2Elabel = val;
    %
    %     switch strrep(lower(searchType),' ','')
    %         case {'fileinanalysis','filesinanalysis'}
    %             srch.return_type = 'file';
    %             srch.filters{1}.
    %         case 'filesinacquisition'
    %             srch.return_type = 'file';
    %             srch.path = 'acquisitions/files';
    %         case {'fileincollection','filesincollection'}
    %             srch.return_type = 'file';
    %
    %             srch.path = 'collections/files';
    %         case 'acquisitionsincollection'
    %             srch.path = 'collections/acquisitions';
    %         case {'sessionincollection','sessionsincollection'}
    %             'filters', {{struct('match', struct('collection0x2Elabel', 'Anatomy Male 45-55'))}});
    %             srch.return_type = 'session';
    %         case 'analysesincollection'
    %             srch.path = 'collections/analyses';
    %         case 'analysesinsession'
    %             srch.path = 'sessions/analyses';
    %         otherwise
    %     end
    
    
    % Build the search structure from the param/val pairs
    n = length(varargin);
    for ii=1:2:n
        
        val = varargin{ii+1};
        
        switch stParamFormat(varargin{ii})
            
            % OVERALL SWITCHES
            case {'all_data'}
                % Search all of the data.  By default you search only your
                % own data
                all_data = val;
            case {'summary'}
                % Printout a summary description of the return cell array
                summary = val;
            
            % PROJECTS
            case {'projectlabelcontains'}
                % 'filters', {{struct('match', struct('project0x2Elabel', 'vwfa'))}}
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.project0x2Elabel = val;
                else
                    srch.filters{end+1}.match.project0x2Elabel = val;
                end
            case {'projectlabelexact','projectlabel'}
                if ~isfield(srch,'projects')
                    srch.projects.bool.must{1}.match.exact_label = val;
                else
                    srch.projects.bool.must{end + 1}.match.exact_label = val;
                end
            case {'projectid'}
                % Note the ugly x0x5F, needed for jsonio
                % filters', {{struct('term', struct('project0x2E_id'
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.project0x2E_id = val;
                else
                    srch.filters{end+1}.term.project0x2E_id = val; 
                end
            case{'projectgroup'}
                if ~isfield(srch,'projects')
                    srch.projects.bool.must{1}.match.group = val;
                else
                    srch.projects.bool.must{end + 1}.match.group = val;
                end
                
            % SESSIONS
            case {'sessionlabelcontains'}
                % srch.sessions.match.label = val;
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.session0x2Elabel = val;
                else
                    srch.filters{end + 1}.match.session0x2Elabel = val;
                end
            case {'sessionlabelexact','sessionlabel'}
                %srch.sessions.match.exact_label = val;
                if ~isfield(srch,'sessions')
                    srch.sessions.bool.must{1}.match.exact_label = val;
                else
                    srch.sessions.bool.must{end + 1}.match.exact_label = val;
                end
            case 'sessionid'
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.session0x2E_id = val;
                else
                    srch.filters{end+1}.term.session0x2E_id = val; 
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
            case {'sessioncontainsanalysis','sessioncontainsanalysislabel'}
                if ~isfield(srch,'sessions')
                    srch.sessions.bool.must{1}.match.analyses0x2Elabel = val;
                else
                    srch.sessions.bool.must{end + 1}.match.analyses0x2Elabel = val;
                end
            case {'sessioncontainssubject'}
                if ~isfield(srch,'sessions')
                    srch.sessions.bool.must{1}.match.subject0x2Ecode = val;
                else
                    srch.sessions.bool.must{end + 1}.match.subject0x2Ecode = val;
                end
                
            % ANALYSES
            case {'analysislabelexact','analysislabel'}
                if ~isfield(srch,'analyses')
                    srch.analyses.bool.must{1}.match.exact_label= val;
                else
                    srch.analyses.bool.must{end + 1}.match.exact_label = val;
                end
            case {'analysislabelcontains'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.analysis0x2Elabel = val;
                else
                    srch.filters{end + 1}.match.analysis0x2Elabel = val;
                end
            case {'analysisid'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.analysis0x2E_id = val;
                else
                    srch.filters{end+1}.term.analysis0x2E_id = val; 
                end
                
            % ACQUISITIONS
            case {'acquisitionid'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.acquisition0x2E_id = val;
                else
                    srch.filters{end+1}.term.acquisition0x2E_id = val; 
                end
            case {'acquisitionlabelcontains'}
                if ~isfield(srch,'acquisitions')
                    srch.acquisitions.bool.must{1}.match.label = val;
                else
                    srch.acquisitions.bool.must{end + 1}.match.label = val;
                end
            case {'acquisitionlabelexact','acquisitionlabel'}
                if ~isfield(srch,'acquisitions')
                    srch.acquisitions.bool.must{1}.match.exact_label = val;
                else
                    srch.acquisitions.bool.must{end + 1}.match.exact_label = val;
                end
                
            % COLLECTIONS                    
            case {'collectionlabelcontains'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.collection0x2Elabel = val;
                else
                    srch.filters{end + 1}.match.collection0x2Elabel = val;
                end
            case {'collectionlabelexact','collectionlabel'}
                if ~isfield(srch,'collections')
                    srch.collections.bool.must{1}.match.exact_label = val;
                else
                    srch.collections.bool.must{end + 1}.match.exact_label = val;
                end
            case {'collectionid'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.collection0x2E_id = val;
                else
                    srch.filters{end+1}.term.collection0x2E_id = val;
                end
                
            % FILES
            case {'filenamecontains'}
                if ~isfield(srch,'files')
                    srch.files.bool.must{1}.match.name = val;
                else
                    srch.files.bool.must{end + 1}.match.name = val;
                end
            case {'filenameexact','filename'}
                if ~isfield(srch,'files')
                    srch.files.bool.must{1}.match.exact_name = val;
                else
                    srch.files.bool.must{end + 1}.match.exact_name = val;
                end
            case {'filetype'}
                % Nifti, dicom, bvec, bval,montage ...
                % struct('term', struct('file0x2Etype', 'nifti'))}});
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.file0x2Etype = val;
                else
                    srch.filters{end+1}.term.file0x2Etype = val;
                end
            case {'filemeasurement', 'measurement'}
                % Localizer, Anatomy_t1w, Calibration, High_order_shim,
                % Functional, Anatomy_inplane, Diffusion
                if ~isfield(srch,'files')
                    srch.files.bool.must{1}.match.measurements = val;
                else
                    srch.files.bool.must{end + 1}.match.measurements = val;
                end
                
            % SUBJECTS    
            case {'subjectcode'}
                if ~isfield(srch,'sessions')
                    srch.sessions.bool.must{1}.match.subject0x2Ecode = val;
                else
                    srch.sessions.bool.must{end + 1}.match.subject0x2Ecode = val;
                end
            case {'subjectagegt'}
                % Subject age greater than
                if ~isfield(srch,'sessions')
                    srch.sessions.bool.must{1}.range.subject0x2Eage.gt= year2sec(val);
                else
                    srch.sessions.bool.must{end + 1}.range.subject0x2Eage.gt = year2sec(val);
                end
            case {'subjectagelt'}
                % Subject age less than
                if ~isfield(srch,'sessions')
                    srch.sessions.bool.must{1}.range.subject0x2Eage.lt= year2sec(val);
                else
                    srch.sessions.bool.must{end + 1}.range.subject0x2Eage.lt = year2sec(val);
                end
%             case {'subjectage', 'age'}
%                 % Subject age
%                 if ~isfield(srch,'sessions')
%                     srch.sessions.bool.must{1}.match.subject0x2Eage = year2sec(val);
%                 else
%                     srch.sessions.bool.must{end + 1}.match.subject0x2Eage = year2sec(val);
%                 end
            case {'subjectsex'}
                % val must be 'male' or 'female'
                % Not working properly yet - BW!!!
                if ~isfield(srch,'sessions')
                    srch.sessions.bool.must{1}.match.subject0x2Esex= val;
                else
                    srch.sessions.bool.must{end + 1}.match.subject0x2Esex = val;
                end
                       
            otherwise
                error('Unknown search parameter: %s\n',varargin{ii});
        end
        
    end
end

%% Save the search struct for possible return
srchResult = obj.fw.search(srch).results;

if isfield(srchResult,'message')
    fprintf('Search error\n');
    fprintf('Status code: %d\n',srchResult.status_code);
    fprintf('Message:     %s\n',srchResult.message);
    return;
end

% Sometimes the result is empty.  Typically it is a struct.
% result = stParseSearch(obj,srchResult);

result  = cell(length(srchResult),1);
% What is the x_id at the top, results(ii).x_id??
for ii=1:length(srchResult)
    result{ii} = srchResult(ii).x_source;
end


%% If the search file is not returned, delete it
% if nargout == 1,  delete(srchFile); end

%% If summary flag is set, do this

if summary
    % This summary will get bigger and better and more helpful.
    fprintf('Number of %s found:  %d\n',searchType, length(result));
end


return;

%% Convert the Matlab struct to json text


% srch = jsonwrite(srch,struct('indent','  ','replacementstyle','hex'));
% srch = regexprep(srch, '\n|\t', ' ');
% srch = regexprep(srch, ' *', ' ');
% 
% 
% % The all_data flag ... what does it do?
% esCMD = obj.searchCmd(srch,'all_data',all_data);

%% Run the elastic search curl command

% result is a string with a bunch of stuff RF put in it, including timing
% information and the json output file.  We get the filename below.

% [~, result] = system(esCMD);

%% Clean up the result

% Load the result json file. NOTE the use of strtrim to get rid of the
% final blank character
% if ismac
%     srchFile = strtrim(result(strfind(result,'/private/tmp'):end));
% elseif isunix
%     srchFile = strtrim(result(strfind(result,'/tmp'):end));
% end

% This is now a Matlab struct with a lot of ugly terms.  We clean them up
% below.
% if ~exist(srchFile,'file'), error('Results does not contain a valid search file');
% else
%     % disp('Running jsonread on returned file');
%     %    tic
%     % srchResult = loadjson(srchFile);
%     srchResult = jsonread(srchFile);
%     %   toc
% end


end
