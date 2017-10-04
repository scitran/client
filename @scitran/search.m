function [result, srch] = search(obj,srch,varargin)
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
%  result:  Array of returned data structs
%  srch:    The structure defined by the search varargins
%
% Parameters
%   Many parameter/value pairs are possible to define the search.  For the
%   common simple search arguments, see the examples in *s_stSearches*.
%
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
%  x0x2E in the Matlab variable. 
%  Matlab does not allow a lead underscore, so we must use x0x5F
%  at the beginning of the variable. See v_stJSONio for examples or to
%  test.
%
% This information should go on the wiki page, as well.
% 
%  Searches begin by defining the type of object you would like returned
%  (e.g., files).  Then we define the features of the object.
%
%  We define the features from the slots in the srch structure. The
%  returned object is defined by result_type
%
%   srch.result_type = One of 
%     {'project','session','acquisition', 'file', 'analysis', 'collection'}
%
% Search constraints are further specified by additional parameters, such
% as 
%    'project label contains'
%    'project id'
%    
% 
% Important parameters we use in search are 
%   'name', 'group', 'label', 'id','plink', subject_0x2E_age',
%   'container_id', 'type'.  
%
% A list of searchable terms can be found in the scitran/core
%
%  <https://github.com/scitran/core/wiki/Data-Model Data Model page>.
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
summary = p.Results.summary;

% Not sure how to set the flag to search through all the data
all_data = p.Results.all_data;

%% If srch is a char array, we build a srch structure

% If it is not a char array, it should be a properly formatted struct.
if ischar(srch)    
    % This condition could be moved to a separate function
    % 
    %   srch = searchStruct(searchType,varargin{:});
    %
    
    % Validate the search result_type
    vFunc = @(x)(ismember(x,{...
        'file','session','acquisition','project','collection','analysis'
        }));
    searchType = srch;
    if ~vFunc(strrep(lower(searchType),' ',''))
        error('Unknown search return type %s\n',searchType);
    end
    
    % Make sure the varargin is parameter/val pairs
    if mod(length(varargin),2)
        error('Must have an even number of param/val varargin');
    end
    
    clear srch
    srch.return_type = searchType;
    
    % Build the search structure from the param/val pairs
    n = length(varargin);
    for ii=1:2:n
        
        val = varargin{ii+1};
        
        switch stParamFormat(varargin{ii})
            
            % OVERALL SWITCHES
            case {'all_data'}
                % Search all of the data.  By default you search only your
                % own data.
                % Force to be logical
                if p.Results.all_data, val = true; 
                else, val = false; 
                end
                srch.all_data = val;
            case {'summary'}
                % Printout a summary description of the return cell array
                summary = val;
            
            % PROJECTS
            case {'projectlabelcontains'}
                % struct('filters', {{struct('match', struct('project0x2Elabel', 'vwfa'))}})
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.project0x2Elabel = val;
                else
                    srch.filters{end+1}.match.project0x2Elabel = val;
                end
            case {'projectlabelexact','projectlabel'}
                % Note the cell here, which is not used in the
                % contains case.
                if ~isfield(srch,'projects')
                    srch.filters{1}.terms.project0x2Elabel = {val};
                else
                    srch.filters{end+1}.terms.project0x2Elabel = {val};
                end
                %                 searchStruct = struct('return_type', 'project', ...
                %                     'filters', {{struct('term', struct('project0x2Elabel', 'vwfa'))}});
                %                 results = fw.search(searchStruct);
            case {'projectid'}
                % This is like project._id, I think.
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
                % st.search('session','session label exact',STRING);
                if ~isfield(srch,'projects')
                    srch.filters{1}.terms.session0x2Elabel = {val};
                else
                    srch.filters{end+1}.terms.session0x2Elabel = {val};
                end
            case 'sessionid'
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.session0x2E_id = val;
                else
                    srch.filters{end+1}.term.session0x2E_id = val; 
                end
            case {'sessionaftertime'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.range.session0x2Ecreated.gte = val;
                else
                    srch.filters{end + 1}.range.session0x2Ecreated.gte = val;
                end
            case {'sessionbeforetime'}
                % Guessing
                if ~isfield(srch,'filters')
                    srch.filters{1}.range.session0x2Ecreated.lte = val;
                else
                    srch.filters{end + 1}.range.session0x2Ecreated.lte = val;
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
            case {'analysislabelcontains'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.analysis0x2Elabel = val;
                else
                    srch.filters{end + 1}.match.analysis0x2Elabel = val;
                end
            case {'analysislabelexact','analysislabel'}
                if ~isfield(srch,'projects')
                    srch.filters{1}.terms.analysis0x2Elabel = {val};
                else
                    srch.filters{end+1}.terms.analysis0x2Elabel = {val};
                end
            case {'analysisid'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.analysis0x2E_id = val;
                else
                    srch.filters{end+1}.term.analysis0x2E_id = val; 
                end
                
            % ACQUISITIONS
            case {'acquisitionlabelcontains'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.acquisition0x2Elabel = val;
                else
                    srch.filters{end+1}.match.acquisition0x2Elabel = val;
                end                
            case {'acquisitionlabelexact','acquisitionlabel'}
                if ~isfield(srch,'projects')
                    srch.filters{1}.terms.acquisition0x2Elabel = {val};
                else
                    srch.filters{end+1}.terms.acquisition0x2Elabel = {val};
                end
            case {'acquisitionid'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.acquisition0x2E_id = val;
                else
                    srch.filters{end+1}.term.acquisition0x2E_id = val;
                end
    
            % COLLECTIONS                    
            case {'collectionlabelcontains'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.collection0x2Elabel = val;
                else
                    srch.filters{end + 1}.match.collection0x2Elabel = val;
                end
            case {'collectionlabelexact','collectionlabel'}
                if ~isfield(srch,'projects')
                    srch.filters{1}.terms.collection0x2Elabel = {val};
                else
                    srch.filters{end+1}.terms.collection0x2Elabel = {val};
                end
            case {'collectionid'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.collection0x2E_id = val;
                else
                    srch.filters{end+1}.term.collection0x2E_id = val;
                end
                
            % FILES
            case {'filenamecontains'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.name = val;
                else
                    srch.filters{end + 1}.match.name = val;
                end
            case {'filenameexact','filename'}
                % NEEDS CHECKING
                if ~isfield(srch,'projects')
                    srch.filters{1}.terms.filename0x2Elabel = {val};
                else
                    srch.filters{end+1}.terms.filename0x2Elabel = {val};
                end
            case {'fileid'}
                % Not tested.
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.file0x2E_id = val;
                else
                    srch.filters{end+1}.term.file0x2E_id = val;
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
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.measurements = val;
                else
                    srch.filters{end + 1}.term.measurements = val;
                end
                
            % SUBJECTS    
            case {'subjectcode'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.subject0x2Ecode = val;
                else
                    srch.filters{end + 1}.match.subject0x2Ecode = val;
                end
            case {'subjectagerange'}
                % s = st.search('session','subject age range',[90.1 96]);  
                % s = st.search('session','subject age range',[70.1 76]);  
                % Subject age range in years
                % If you set  age range twice, it is AND.  Not needed.
                if ~isfield(srch,'filters')
                    srch.filters{1}.range.subject0x2Eage.gt= year2sec(val(1));
                    srch.filters{1}.range.subject0x2Eage.lt= year2sec(val(2));
                else
                    srch.filters{end + 1}.range.subject0x2Eage.gt= year2sec(val(1));
                    srch.filters{end + 1}.range.subject0x2Eage.lt= year2sec(val(2));
                end
            case {'subjectsex'}
                % val must be 'male' or 'female'
                % st.search('session','subject sex','male');
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.subject0x2Esex = val;
                else
                    srch.filters{end + 1}.match.subject0x2Esex = val;
                end
                       
            otherwise
                error('Unknown search parameter: %s\n',varargin{ii});
        end
        
    end
end

%% Perform the search

%{

% For convenience, you might want to look at the JSON
% created in the Flywheel.search method.
 oldField = 'id';
 newField = 'x0x5Fid';
 search_query = obj.fw.replaceField(srch,oldField,newField);
 opts = struct('replacementStyle','hex');
 search_query = jsonwrite(srch,opts);
%}

srchResult = obj.fw.search(srch).results;

if isfield(srchResult,'message')
    fprintf('Search error\n');
    fprintf('Status code: %d\n',srchResult.status_code);
    fprintf('Message:     %s\n',srchResult.message);
    return;
end

% Convert to cell array.  I tried allocating structs, but this turns out
% not be easy. See 
% https://www.mathworks.com/matlabcentral/answers/12912-how-to-create-an-empty-array-of-structs
result = cell(length(srchResult),1);
for ii=1:length(srchResult)
    result{ii} = srchResult(ii).x_source;
end

%% If summary flag is set, do this

if summary
    % This summary might get more helpful.  Or deleted.
    fprintf('Found %d (%s)\n',length(result), searchType);
end


end

%% Old code, deprecated.  But might be useful

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

