function [id, dataType] = idGet(data,varargin)
% Return the id of a Flywheel data object
%
% Syntax
%   [id, dataType] = idGet(data, ...)
%
% Desription
%   Return the id from different Flywheel container and object types. When
%   the input is from a search response, we need to ahve the data type
%   returned.  BW asked JE if he could add that slot to the search
%   response, so then we wouldn't need the 'data type' parameter.
%
% Input
%   data: A struct with Flywheel information either in search or SDK
%         format
%
% Optional key/value inputs
%   "data type" - One of the possible data types.  Needed for search, but
%   not when the data are returned by scitran.list.s
%s
% Return:
%   id:   If data is a single object, the return is a string.  
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
idGet(projects{1},'data type','project')
idGet(projects,'data type','project')
%}
%{
sessions = st.search('session','project label exact','VWFA');
idGet(sessions{1},'data type','session')
idGet(sessions,'data type','session')
%}
%{
acquisitions = st.search('acquisition',...
   'project label exact','VWFA',...
   'session label exact',sessions{1}.session.label);
idGet(acquisitions{1})
idGet(acquisitions,'data type','acquisition')
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
% Notice that no data type is required for the idGet in this case.
 projects = st.list('project','wandell');
 projID = idGet(projects{1});
 idGet(projects)
 sessions = st.list('session',projID);
 id = idGet(sessions)
 acquisitions = st.list('acquisition',id{1});
 id = idGet(acquisitions)
 id = idGet(acquisitions{1})
%}
%{
% We need to add the collection tests when that is fixed in Flywheel
%}

%%
disp('To be deprectaed. Consider using stObjectParse instead');

%%
p = inputParser;
varargin = stParamFormat(varargin);

vFunc = @(x)(strncmp(class(x),'flywheel.model',14) || ...
            (iscell(x) && strncmp(class(x{1}),'flywheel.model',14)));
p.addRequired('data',vFunc);
p.addParameter('datatype','',@ischar);

p.parse(data,varargin{:});

% dataType = p.Results.datatype;

%% Determine if is struct or cell array of structs

nData = numel(data);  
if nData > 1
    % Cell array of inputs, so cell array of outputs
    % But every cell should be the same type!
    dataType = stModel(data{1});
else
    dataType = stModel(data);
end

if isequal(dataType,'file')
    error('Files do not have an id. They have a parentID and a name.');
end

%% See if we are dealing with a search response

% In this case, we need to have the user tell us what type of model we
% are dealing with.

srch = false;
if isequal(dataType,'searchresponse')
    srch = true;
    dataType = p.Results.datatype;
    if isempty(dataType)
        error('You must specify the data type for a search response');
    end
end

%% Read the id values according to the type of data

if srch
    if nData == 1, id = data.(dataType).id;
    else,          id = cellfun(@(x)(x.(dataType).id),data);
    end
else
    if nData == 1, id = data.id;
    else,          id = cellfun(@(x)(x.id),data,'UniformOutput',false);
    end
end

end
