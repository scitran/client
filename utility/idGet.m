function id = idGet(data,varargin)
% Return the id of a Flywheel data object
%
% Syntax
%   idGet(data, ...)
%
% Brief desription
%   Different Flywheel objects 
%
% Input
%   data: A struct with Flywheel information either in search or SDK
%         format; possibly a cell array of such structs
%
% Optional key/value inputs
%   
% Return:
%   id:   If data is a single struct, the return is a string.  
%         If data is a cell array of data, id is a cell array of strings.
%
% BW, Vistalab 2017

% Examples
%{
% Checking for the search type containers
group = 'wandell';
projects = st.search('project',...
    'group name',group,...
    'summary',true);
idGet(projects{1})
idGet(projects)
%}
%{
sessions = st.search('session','project label exact','VWFA');
idGet(sessions{1})
idGet(sessions)
%}
%{
acquisitions = st.search('acquisition',...
   'project label exact','VWFA',...
   'session label exact',sessions{1}.session.label);
idGet(acquisitions{1})
idGet(acquisitions)
%}
%{
files = st.search('file',...
   'project label exact','VWFA',...
   'session label exact',sessions{1}.session.label,...
   'acquisition label exact',acquisitions{1}.acquisition.label);
idGet(files{1})
idGet(files)
%}
%{
% Checking for the SDK type containers
projects = st.list('project','wandell');
projID = idGet(projects{1});
idGet(projects)
sessions = st.list('session',projID);
id = idGet(sessions)
acquisitions = st.list('acquisition',id{1});
id = idGet(acquisitions)
id = idGet(acquisitions{1})

% We need to add the collection tests when that is fixed in Flywheel
%}
%%
p = inputParser;
varargin = stParamFormat(varargin);

p.addRequired('data',@(x)(isa(x,'flywheel.model.SearchResponse')));
validTypes = {'project','session','acquisition','file','collection','analysis'};
p.addParameter('datatype','none',@(x)(ismember(x,validTypes)));

p.parse(data,varargin{:});
dataType = p.Results.datatype;

%% Determine if is struct or cell array of structs

% if iscell(data), objType = 'cell'; 
% else,            objType = 'struct';
% end

nData = numel(data);
if nData > 1, id = cell(nData,1); end

% This does not work.  We need Justin to change the swagger code.
% Or we need to get him to put a slot that always identifies the type
% of object that is returned by the search (i.e., return type).
if strcmp(dataType,'none')
    % We find the finest resolution in the list and return the id for
    % that dataType
    if     ~isempty(data.file), dataType        = 'file';
    elseif ~isempty(data.acquisition), dataType = 'acquisition';
    elseif ~isempty(data.session), dataType     = 'session';
    elseif ~isempty(data.project), dataType     = 'project';
    elseif ~isempty(data.collection), dataType  = 'collection';
    elseif ~isempty(data.analysis), dataType    = 'analysis';
    else
        error('Cannot identify dataType');
    end
end

% % Determine whether a search type or a list type
% srch = true;
% if strcmp(objType,'cell')
%     if isfield(data{1},'id'), srch = false; end
% else
%     if isfield(data(1),'id'), srch = false; end
% end

%% Read the id values

if nData == 1
    id = data.(dataType).id;
else
    for ii=1:nData
        id{ii} = data(ii).(dataType).id;
    end
end


end


