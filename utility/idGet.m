function id = idGet(data)
% Return the id of the Flywheel data object
%
% Syntax
%   idGet(data)
%
% Brief desription
%   The scitran search returns a struct that contains an object's idea, and
%   the Flywheel sdk returns a slightly different struct that also contains
%   an object's id.  This routine determines which type if struct is passed
%   in, extracts the id and returns it.
%
% Input
%   data: A struct with Flywheel information either in search or SDK
%         format; possibly a cell array of such structs
%
% Return:
%   id:   If data is a single struct, the return is a string.  If data is a
%         cell array of structs, id is a cell array of strings.
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

sessions = st.search('session','project label exact','VWFA');
idGet(sessions{1})
idGet(sessions)

acquisitions = st.search('acquisition',...
   'project label exact','VWFA',...
   'session label exact',sessions{1}.session.label);
idGet(acquisitions{1})
idGet(acquisitions)

files = st.search('file',...
   'project label exact','VWFA',...
   'session label exact',sessions{1}.session.label,...
   'acquisition label exact',acquisitions{1}.acquisition.label);
idGet(files{1})
idGet(files)

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
p.addRequired('data',@(x)(isstruct(x) || iscell(x)));
p.parse(data);

%% Determine if is struct or cell array of structs

if iscell(data), objType = 'cell'; 
else,            objType = 'struct';
end

nData = numel(data);
if nData > 1, id = cell(nData,1); end

% Determine whether a search type or a list type
srch = true;
if strcmp(objType,'cell')
    if isfield(data{1},'id'), srch = false; end
else
    if isfield(data(1),'id'), srch = false; end
end

%% Read the id values
switch objType
    case 'struct'
        for ii=1:nData
            if srch, id{ii} = idSearch(data(ii));
            else,    id{ii} = data(ii).id;
            end
        end

    case 'cell'
        for ii=1:nData
            if srch,  id{ii} = idSearch(data{ii});
            else,     id{ii} = data{ii}.id;
            end
        end

    otherwise
        error('Unknown objType %s.  Search is %s\n', objType, srch);
end

if nData == 1, id = id{1}; end

end

function id = idSearch(data)
% We have a search struct, but not clear which type of object.  So we work
% our way through the list.

if isfield(data,'file')
    % warning('File.  Returning parent (acquisition) id.');
    id = data.parent.x_id;
elseif isfield(data,'acquisition')
    id = data.acquisition.x_id;
elseif isfield(data,'session')
    id = data.session.x_id;
elseif isfield(data,'project')
    id = data.project.x_id;
elseif isfield(data,'collection')
    disp('Collection not correctly implemented yet');
    % id = data.collection.x_id;
else
    error('Unknown object type');
end


end

