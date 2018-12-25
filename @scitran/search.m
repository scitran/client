function [result, srch] = search(obj,srch,varargin)
% Run a search within a Flywheel database
%
% Syntax:
%  [srchResult, srch] = st.search(srch, ...)
%
% Description:
%   This scitran search method that returns database information about
%   files, acquisitions, sessions, projects, collections and groups on a
%   Flywheel site. The returned information consists of cell arrays
%   describing the database objects.
%
%   To access the values in these objects, we use the scitran methods
%   starting with either 'get' or 'download'.  The 'get' routines return
%   values about the objects, and the 'download' methods bring the
%   information from the database, usually files, to the local file system.
%   
%   The 'search' method provides information about the number and identity
%   of files meeting certain criteria (e.g., nifti files in a project
%   representing T1 anatomical).  The 'get' method provides information
%   about the values of these objects (e.g., TR, TI, TE, nSlices).  The
%   'download' and 'read' methods return the file data themselves.
%
% Input:
%   srch:  The returned object - a struct or a string 
%      If a string, then the search return type. In this case, we
%      build the struct from the parameter/value pairs in varargin. The
%      valid return types are 
%
%      {'file','acquisition','session','project',
%            'group', 'collection','analysis'}
%
%      If a struct, the fields that define the search parameters must
%      include srch.returnType and other parameters.
%
% Optional inputs
%   Many parameter/value pairs are possible to define the search.  For 
%   common search arguments, see the examples in *s_stSearches*.
%
%   In addition to the search parameters, there are two special parameters
%
%     'allData'   - sets whether to search the entire database, including
%                    projects that you do not have access to (boolean,
%                    default false} 
%     'summary'    - print out a summary of the number of search items
%                    returned (boolean, default false}
%     'limit'      - upper limit on the number of returned objects
%
% Returns:
%  result:  A cell array of data structs that match the search parameters
%  srchCmd: A struct that contains the search parameters
%
% Running these commands in sequence return the same results
%      [results,srchCmd] = st.search(srch,'parameter',value);
%      results = st.search(srchCmd);
% 
%   See also: s_stSearches.m, scitran client wiki page
%
% List of the search parameters should be included here
%
% BW/LMP Vistalab 2016
%
% See also:
%  s_stSearches
%

% Examples:
%{
 st = scitran('stanfordlabs'); st.verify;
 p = st.search('project','project label exact','VWFA');
 id = p{1}.project.id
%}
%{
 allProjects = st.list('project','all')
 stPrint(allProjects,'label','')
%}
%{
% When debugging, convenience, you might want to look at the JSON
% created in the Flywheel.search method.
 oldField = 'id';
 newField = 'x0x5Fid';
 search_query = obj.fw.replaceField(srch,oldField,newField);
 opts = struct('replacementStyle','hex');
 search_query = jsonwrite(srch,opts);
%}

% Programming Notes
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
% Search constraints are further specified by additional parameters, such
% as 
%    'project label contains'
%    'project id'
%    
% A description of the general data model that defines searchable terms can
% be found in the command line SDK documentation
%
%   ???
%
% and in the data model
%
%  <https://github.com/scitran/core/wiki/Data-Model Data Model page>.
% 

%% Could check the srch struct here for the appropriate fields
%
p = inputParser;
p.KeepUnmatched = true;

% Could be a string or a struct.  If a string, then we are in the simple
% search case.
p.addRequired('srch');  

% Not sure what this means yet
p.addParameter('alldata',false,@islogical);
p.addParameter('summary',false,@islogical);
p.addParameter('sortlabel',[],@ischar);

% -1 is unlimited.  But it turns out Flywheel has a limit
p.addParameter('limit',10000,@isscalar);   % Max allowed by flywheel

% This enables doing a search for a group for 
%  st.search('group','all'); or st.search('group','all labels');
% without adding the additional logical - st.search('group','all',true);
%
if (strcmp(srch,'group') && length(varargin) == 1), varargin{2} = true; end

% Configure the varargin for different search cases, starting either with a
% struct or the parameter/value cases
if ~isempty(varargin) && isstruct(varargin{1})
    % Convert the srch struct to be the parameter/value cell aray    
    fields = fieldnames(varargin{1});
    fieldvals = struct2cell(varargin{1});
    for ii=1:2:length(fields)
        varargin{ii}   = stParamFormat(fields{ii});
        varargin{ii+1} = fieldvals{ii};
    end
else
    varargin = stParamFormat(varargin);    
end

p.parse(srch,varargin{:});

srch      = p.Results.srch;
summary   = p.Results.summary;
sortlabel = p.Results.sortlabel;
allData   = p.Results.alldata;
limit     = p.Results.limit;

%% If srch is a char array, we build a srch structure

% If it is not a char array, it should be a properly formatted struct.
if ischar(srch)    
    
    % Deal with special case of group searches
    if strcmp(srch,'group')
        % This might become its own function
        
        % We might move this to a call to searchGroup
        switch stParamFormat(varargin{1})
            case 'all'
                % st.search('group','all');
                result = obj.fw.getAllGroups;
            case 'alllabels'
                tmp = obj.fw.getAllGroups;
                result = cell(length(tmp),1);
                for ii=1:length(tmp)
                    result{ii} = tmp{ii}.label;
                end
            case 'allnames'
                tmp = obj.fw.getAllGroups;
                result = cell(length(tmp),1);
                for ii=1:length(tmp)
                    result{ii} = tmp{ii}.id;
                end
            case 'name'
                % st.search('group','name','wandell');
                % Returns the struct for the group
                result = obj.fw.getGroup(varargin{2});
            case 'users'
                % users = st.search('group','users','wandell')
                if length(varargin) < 2
                    error('Group label required');
                end
                g = obj.fw.getGroup(varargin{2});
                result = cell(numel(g.permissions),1);
                for ii=1:numel(g.permissions)
                    result{ii} = g.permissions{ii}.id;
                end
            otherwise
                error('Unknown group search term: %s',varargin{1});
        end
        
        return;
    end
    
    % Make sure the varargin is parameter/val pairs
    if mod(length(varargin),2)
        error('Must have an even number of param/val varargin');
    end
    
    % One of the standard return types
    % Force to lower and singular.  Also check that it is a permissible type.
    searchType = formatSearchType(srch); 
    clear srch
    srch.returnType = searchType;
  
    % Build the search structure from the param/val pairs
    n = length(varargin);
    for ii=1:2:n
        
        val = varargin{ii+1};
        
        switch stParamFormat(varargin{ii})
            
            % GENERAL SEARCH PARAMETERS
            case {'alldata'}
                % Search all of the data.  
                % By default you search only your own data.
                % Force to be logical
                if allData, val = true; 
                else, val = false; 
                end
                srch.allData = val;
            case {'sortlabel'}
                % Ignore - We manage this at the end.
            case {'summary'}
                % Logical - Printout a summary description of the return cell array
                summary = val;
            case {'limit'}
                % We manage an upper limit on the number of returns
                % at the end. 
                limit = val;
            % GROUP
            case{'group'}
                % Exact match to group name
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.group0x2E_id = val;
                else
                    srch.filters{end + 1}.match.group0x2E_id = val;
                end
            case {'groupname'}
                % Each group has a name, which is also its id
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.group0x2E_id = val;
                else
                    srch.filters{end + 1}.match.group0x2_id = val;
                end
            case {'grouplabel'}
                % Each group has a label in addition to a group name
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.group0x2Elabel = val;
                else
                    srch.filters{end + 1}.match.group0x2label = val;
                end
                
            % PROJECTS
            case {'projectlabelcontains'}
                % struct('filters', {{struct('match', struct('project0x2Elabel', 'vwfa'))}})
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.project0x2Elabel = val;
                else
                    srch.filters{end+1}.match.project0x2Elabel = val;
                end
            case {'projectlabelexact'}
                % Note the cell here, which is not used in the
                % contains case.
                if ~isfield(srch,'filters')
                    srch.filters{1}.terms.project0x2Elabel = {val};
                else
                    srch.filters{end+1}.terms.project0x2Elabel = {val};
                end
            case {'projectid'}
                % This is like project._id, I think.
                % filters', {{struct('term', struct('project0x2E_id'
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.project0x2E_id = val;
                else
                    srch.filters{end+1}.match.project0x2E_id = val; 
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
                if ~isfield(srch,'filters')
                    srch.filters{1}.terms.session0x2Elabel = {val};
                else
                    srch.filters{end+1}.terms.session0x2Elabel = {val};
                end
            case 'sessionid'
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.session0x2E_id = val;
                else
                    srch.filters{end+1}.match.session0x2E_id = val; 
                end
            case {'sessionaftertime'}
                % val has the format of a string like
                % 'now-16w'.  A string with no spaces.
                % Also, 'now-2y','now-3d'
                val = stParamFormat(val);
                if ~isfield(srch,'filters')
                    srch.filters{1}.range.session0x2Ecreated.gte = val;
                else
                    srch.filters{end + 1}.range.session0x2Ecreated.gte = val;
                end
            case {'sessionbeforetime'}
                % When the data were placed in the database.  Not the
                % same as the timestamp, which denotes when they were
                % measured.
                val = stParamFormat(val);
                if ~isfield(srch,'filters')
                    srch.filters{1}.range.session0x2Ecreated.lte = val;
                else
                    srch.filters{end + 1}.range.session0x2Ecreated.lte = val;
                end
            case {'sessionmeasuredbeforetime'}
                % When the data were placed in the database.  Not the
                % same as the timestamp, which denotes when they were
                % measured.
                val = stParamFormat(val);
                if ~isfield(srch,'filters')
                    srch.filters{1}.range.session0x2Etimestamp.lte = val;
                else
                    srch.filters{end + 1}.range.session0x2Etimestamp.lte = val;
                end
            case {'sessionmeasuredaftertime'}
                % val has the format of a string like
                % 'now-16w'
                val = stParamFormat(val);
                if ~isfield(srch,'filters')
                    srch.filters{1}.range.session0x2Etimestamp.gte = val;
                else
                    srch.filters{end + 1}.range.session0x2Etimestamp.gte = val;
                end
            case {'sessioncontainsanalysis','sessioncontainsanalysislabel'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.analyses0x2Elabel = val;
                else
                    srch.filters{end + 1}.match.analyses0x2Elabel = val;
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
                    srch.filters{1}.match.analysis0x2E_id = val;
                else
                    srch.filters{end+1}.match.analysis0x2E_id = val; 
                end
 
            % Gears
            case {'gearname'}
                % TUse this to find analyses that were generated by a
                % gear with this name
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.analysis0x2Egear_info0x2Ename = val;
                else
                    srch.filters{end+1}.match.analysis0x2Egear_info0x2Ename = val;
                end
            case {'gearversion'}
                % Use this to find an analysis that ran a gear with
                % this version.
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.analysis0x2Egear_info0x2Eversion = val;
                else
                    srch.filters{end+1}.match.analysis0x2Egear_info0x2Eversion = val;
                end
                
                % An analysis was generated by a job. The analysis ran a
                % gear. The job is on the analysis.  The gear parameters
                % are called the config. These are stored in the
                %
                %    job.config
                %
                % in the gear configuration that ...
                
            % ACQUISITIONS
            case {'acquisitionlabelcontains'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.acquisition0x2Elabel = val;
                else
                    srch.filters{end+1}.match.acquisition0x2Elabel = val;
                end                
            case {'acquisitionlabelexact'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.terms.acquisition0x2Elabel = {val};
                else
                    srch.filters{end+1}.terms.acquisition0x2Elabel = {val};
                end
            case {'acquisitionid'}
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.acquisition0x2E_id = val;
                else
                    srch.filters{end+1}.match.acquisition0x2E_id = val;
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
                    srch.filters{1}.match.collection0x2E_id = val;
                else
                    srch.filters{end+1}.match.collection0x2E_id = val;
                end
                
            % FILES AND DATA
            case {'filenamecontains'}
                % NEEDS CHECKING
                if ~isfield(srch,'filters')
                    srch.filters{1}.match.file0x2Ename = val;
                else
                    srch.filters{end + 1}.match.file0x2Ename = val;
                end
            case {'filenameexact','filename'}
                if ~isfield(srch,'projects')
                    srch.filters{1}.terms.file0x2Ename = {val};
                else
                    srch.filters{end+1}.terms.file0x2Ename = {val};
                end
                % There is not yet an id for a file.  When that comes,
                % uncomment this.
                %             case {'fileid'}
                %                 % Not tested.
                %                 if ~isfield(srch,'filters')
                %                     srch.filters{1}.match.file0x2E_id = val;
                %                 else
                %                     srch.filters{end+1}.match.file0x2E_id = val;
                %                 end
            case {'filetype'}
                % Nifti, dicom, bvec, bval,montage ...
                % This checking could include force to lower case and
                % eliminate spaces.  But the Flywheel side does not seem
                % to work that way.
                v = stValid('file type');
                if ~ismember(val,v)
                    fprintf('Valid file types are\n');
                    stValid('file type');
                    error('Invalid file type'); 
                end
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.file0x2Etype = val;
                else
                    srch.filters{end+1}.term.file0x2Etype = val;
                end
            case {'datatype','classification','measurement'} % 'filemeasurement'
                % Localizer, Anatomy_t1w, Calibration, High_order_shim,
                % Functional, Anatomy_inplane, Diffusion
                v = stValid('data type');
                if ~ismember(val,v)
                    fprintf('Valid data types are\n');
                    stValid('file type');
                    error('Invalid file type: %s',val); 
                end
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.measurements = val;
                else
                    srch.filters{end + 1}.term.measurements = val;
                end
                
            % SUBJECTS    
            case {'subjectcode'}
                % This seems to be 'contains', though I am not sure.
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.subject0x2Ecode = val;
                else
                    srch.filters{end + 1}.term.subject0x2Ecode = val;
                end
                
            case {'subjectlastname'}
                % This seems to be 'contains', though I am not sure.
                if ~isfield(srch,'filters')
                    srch.filters{1}.term.subject0x2Elastname = val;
                else
                    srch.filters{end + 1}.term.subject0x2Elastname = val;
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
                
                
            % searchString
            case {'string'}
                % Not sure what this does yet. But it appears to
                % search anywhere in the properties of the returnType
                % that has this string.
                srch.searchString = val;
                       
            otherwise
                error('Unknown search parameter: %s\n',varargin{ii});
        end
        
    end
else
    % The srch term was a struct.  So we need to get searchType
    searchType = srch.returnType;
end


%% Perform the search

% To limit the searches to the top 100, use this
srchResult = obj.fw.search(srch,'size',num2str(limit)); %.results;

if isfield(srchResult,'message')
    fprintf('Search error\n');
    fprintf('Status code: %d\n',srchResult.status_code);
    fprintf('Message:     %s\n',srchResult.message);
    return;
end

% Convert the returned srchResult to a cell array from struct array.
% I tried allocating structs, but this turns out not be easy. 
% See 
% https://www.mathworks.com/matlabcentral/answers/12912-how-to-create-an-empty-array-of-structs

% We discovered that sometimes srchResult is already a cell array, so in
% that case we don't do the conversion.  We should ask Jen R about this,
% but no big deal.
if ~iscell(srchResult)
    result = cell(length(srchResult),1);
    for ii=1:length(srchResult)
        result{ii} = srchResult(ii);
    end
else
    result = srchResult;
end

%% Deal with sortlab or summary flag

if ~isempty(sortlabel)
    fprintf('sort label is not yet implemented. %s\n',sortlabel);
end

if summary
    % This summary might get more helpful.  Or deleted.
    if length(result) < 10000
        fprintf('Found %d (%s)\n',length(result), searchType);
    else
        % We ran up to the limit.  So warn.
        fprintf('Found %d (%s). Limited to %d\n',length(result), searchType, limit);
    end
end


end



