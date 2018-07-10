function result = list(obj, returnType, parentID, varargin)
% List Flywheel containers or files
%
% Syntax
%   result = scitran.list(returnType, parentID, ...)
%
% Description
%  The Flywheel objects and files are organized hierarchically
%
%    Group Name
%     Project Name
%      Session Name
%       Acquisition Name
%        ...
%
% Or,
%
%     Curator Name
%       Collection
%         Session
%           Acquisition
%
% The list function takes the id of a parent, say a project, and then
% lists the sessions in that parent.  Or the parent might be a session
% and the acquisitions are listed.
%
% Inputs (required)
%  returnType - project, session, acquisition, file, collection,
%               collectionsession, collectionacquisition
%  parentID   - A Flywheel ID of the parent container.
%               If the search is for a project, then parentID is the group
%               label, or the string 'all' or '' to indicate all groups.
%
% Inputs (optional)
%  containerType - Used for retrieving files
%  summary:      - Print a brief summary of the returned objects
%
% Return
%  result:  Cell array of flywheel.model objects
%
% Example on Wiki
%  projects     = st.list('project','wandell');
%  sessions     = st.list('session',idGet(projects{5}));     % Pick one ....
%  acquisitions = st.list('acquisition',idGet(sessions{1})); 
%  files        = st.list('file',idGet(acquisitions{1})); 
%
% LMP/BW Vistasoft Team, 2015-16
%
% See also: 
%     scitran.search

% Examples:
%{

  st = scitran('stanfordlabs');

  % The struct returned from an elastic search and from an SDK get differ
  % substantially
  project      = st.search('project','project label exact','VWFA');
  sessions     = st.list('session',idGet(project{1},'data type','project'));

  % The group name (not label) is sent for the project
  projects     = st.list('project','wandell');
  sessions     = st.list('session',projects{5}.id);
  acquisitions = st.list('acquisition',sessions{1}.id); 
  files        = st.list('file',acquisitions{1}.id);  
  stPrint(files,'name','');
%}
%{ 
  % For collection, the curator is sent, rather than the group name
  collections  = st.list('collection','wandell@stanford.edu');
  sessions     = st.list('collection session',collections{1}.id); 
  acquisitions = st.list('collection acquisition',collections{1}.id); 
%}

%% Programming todo
%
% N.B. Acquisition id '56e9d386ddea7f915e81f705' (stanfordlabs ) had a
% problem because it has a field name with a very long string. Matlab
% has a longest permission field name (63), set in namelengthmax.  We
% can't adjust that.  So we need JE to catch this on his end.


%% Parse inputs
p = inputParser;

% Squeeze out spaces and force lower case
returnType = stParamFormat(returnType);
varargin   = stParamFormat(varargin);

p.addRequired('returnType',@ischar);
p.addRequired('parentID',@ischar);

validStrings = {'project','session','acquisition','collection'};
vFunc = @(x)(contains(x,validStrings));
p.addParameter('containertype','acquisition',vFunc);
p.addParameter('summary',false,@islogical);

p.parse(returnType,parentID,varargin{:});

summary = p.Results.summary;
containerType = p.Results.containertype;

% Get the Flywheel commands
fw = obj.fw;

returnType = formatSearchType(returnType);

%%  Call the relevant SDK rouinte
switch returnType
    case 'group'
        % Not sure which subset of gruops is returned by this call.
        % It does not seem to be all of the groups in the instance, just
        % the groups that the user is part of.  Could that be?
        allGroups = fw.getAllGroups;
        data = cellfun(@(x)(x.label),allGroups,'UniformOutput',false);

    case 'project'
        % ParentID is a group label
        %  projects     = st.list('project','wandell');
        %  stPrint(projects,'label','');
        %
        % If ParentID is empty or the string 'all' then all projects, not
        % just for one group, are returned.
        
        if isempty(parentID) || strcmp(parentID,'all')
            data = fw.getAllProjects;
        else
            data = fw.getGroupProjects(parentID);
            
            % Another much longer way to do it.
            %{
             allProjects = fw.getAllProjects;
             allGroups = cellfun(@(x)(x.group),allProjects,'UniformOutput',false);
             lst = strcmp(allGroups,parentID);
             data = allProjects(lst);
            %}
        end
        
    case 'session'
        data = fw.getProjectSessions(parentID);
        
    case 'acquisition'
        % Parent is session
        data = fw.getSessionAcquisitions(parentID);
        
    case 'file'
        % ParentID for the file container can be one of many different
        % types. We get the container and pull out the files from the
        % return.
        
        % We had one case where the file info field contained __ and
        % that broke something.  Maybe jsonread.  
        thisID = parentID;  % In this case, the id is at the same level
        switch containerType
            case 'project'
                % The parentID is an project ID.
                % This seems to work
                this = fw.getProject(thisID);
            case 'session'
                % The parentID is an session ID.
                % This is not working for BW in the VWFA project
                this = fw.getSession(thisID);
            case 'acquisition'
                % The parentID is an acquisition ID.
                % This is not working for BW in the VWFA project
                this = fw.getAcquisition(thisID);
            case 'analysis'
                % Not tested
                this = fw.getAnalysis(thisID);
            otherwise
                error('Unknown container type %s\n',containerType);
        end
        data = this.files;

    
    case 'analysis'
        data = fw.getAnalysis(parentID);
    
    case 'collection'
        % An email address of the curator replaces the groupID/parentID
        data = {};
        tmp = fw.getAllCollections;
        cnt = 1;
        for ii=1:numel(tmp)
            if strcmp(tmp{ii}.curator,parentID)
                data{cnt} = tmp{ii}; %#ok<AGROW>
                cnt = cnt + 1;
            end
        end
        
    case 'collectionsession'
        % Parent is the collection
        data = fw.getCollectionSessions(parentID);
        
    case 'collectionacquisition'
        % Parent is the collection
        data = fw.getCollectionAcquisitions(parentID);
        
    otherwise
        error('Unknown object type %s\n',returnType);
end

%% Formatting data to look like search return, result

% We discovered that sometimes srchResult is already a cell array, so in
% that case we don't do the conversion.  We should ask Jen R about this.
if ~iscell(data)
    if numel(data) == 1
        result{1} = data;
    else
        result = cell(numel(data),1);
        for ii=1:numel(data)
            result{ii} = data(ii);
        end
    end
else
    result = data;
end

%% If requested, then summarize

if summary
    fprintf('Returned %d objects (%s)\n',numel(result), returnType);
end


end

