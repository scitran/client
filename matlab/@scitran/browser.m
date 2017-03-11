function url = browser(obj, varargin)
% Open up the scitran URL to the object id
%
%    url = st.browser(obj, varargin)
%
% Optional parameter/value pairs:
%  stdata:    A struct returned by an st.search command.  We display
%             projects, sessions, acquisitions, and analyses.
%
%  browse:      Bring up the browser (default is true). If set to false,
%               the url is returned, which may be useful.
%  collection:  Set to true to show a session from a collection
%
% Output:
%  url:    The url to a project or session or collection
%
% Examples:
%    st = scitran; srch.path = 'projects';
%    stdata = st.search(srch);
%    st.browser(stdata{1});
%
%  No browser is brought up, but the url is returned;
%    url = st.browser(stdata{1},'browse',false);
%
%  Open the session as part of a collection that contains it
%    clear srch; 
%    srch.path = 'sessions'; srch.collections.match.label='GearTest';
%    stdata = st.search(srch);
%    srch.path = 'collections'; srch.collections.match.label='GearTest';
%    collection = st.search(srch);
%    url = st.browser(stdata{1},'collection',collection{1});
%
% BW  Scitran Team, 2016

%% Parse the inputs
p = inputParser;

% stdata is a returned search object from the st.search The browser can
% open up an object that is a project, session, acquisition, or analysis
% If none is passed in, then we just open up the url of the instance ('').
vFunc = @(x) (isstruct(x) && ismember(x.type, {'projects','sessions','acquisitions','collections','analyses',''}));
p.addParameter('stdata','',vFunc);

% Bring up the browser window
p.addParameter('browse',true,@islogical);

% If this exists, then it must be a struct.
c.c = false;
p.addParameter('collection',c,@isstruct);

p.parse(varargin{:});
stdata      = p.Results.stdata;
browse      = p.Results.browse;
collection  = p.Results.collection;

%% Build the web URL

if isempty(stdata)
    % No st data sent in, so upon up the root
    url = sprintf('%s',obj.url);
end

if isfield(collection,'id')
    % Show a session in the context of a collection.
    url = sprintf('%s/#/dashboard/collection/%s/session/%s?tab=data',obj.url,collection.id,stdata.id);
elseif ~isempty(stdata)
    % We show a session, acquisition in the context of the project, not 
    switch stdata.type
        case {'acquisitions'}
            % We show the session for an acquisition.
            url = sprintf('%s/#/dashboard/session/%s',obj.url,stdata.source.session);
        case {'analyses'}
            % Analyses are always part of a collection or session. If part
            % of a collection, we show the session within the collection.
            % The user must select the Analyses tab.  If part of a session,
            % we should do something else.  But not ready for that yet
            %
            % Not thoroughly debugged.
            url = sprintf('%s/#/dashboard/collection/%s',obj.url,stdata.source.container.id);
        otherwise
            % This is the case for a projects, sessions, collections in a project
            url = sprintf('%s/#/dashboard/%s/%s',obj.url,stdata.type(1:(end-1)),stdata.id);
    end
end

%% Show, if requested

if browse, web(url,'-browser'); end

%%