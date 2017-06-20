function url = browser(obj, stdata, varargin)
% Open up the scitran URL to the object id
%
%    url = st.browser(obj, stdata, varargin)
%
% Required parameter
%  stdata:    A struct returned by an st.search command.  We display
%             projects, sessions, acquisitions, and analyses.
%
% Optional parameters
%  browse:      Bring up the browser (default is true). If set to false,
%               the url is returned, which may be useful.
%  collection:  Set to true to show a session from a collection
%  tab:         Choose the display tab
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
%    stdata = st.search('sessions','project label','VWFA');
%    st.browser(stdata{1});
%
%    stdata = st.search('collections','collection label','Visualization');
%    url = st.browser('','collection',stdata{1});
%
% BW  Scitran Team, 2016

%% Parse the inputs
p = inputParser;

if ~exist('stdata','var'), stdata = []; end

% stdata is a returned search object from the st.search The browser can
% open up an object that is a project, session, acquisition, or analysis
% If none is passed in, then we just open up the url of the instance ('').
vFunc = @(x) (isempty(x) || ...
    isstruct(x) && ismember(x.type, {'projects','sessions','acquisitions','collections','analyses',''}));
p.addRequired('stdata',vFunc);

% Bring up the browser window
p.addParameter('browse',true,@islogical);

vFunc = @(x) (isempty(x) || ismember(x, {'analysis','data','jobs','project','annotation','subject'}));
p.addParameter('tab','',vFunc);

% If this exists, then it must be a struct.
c.c = false;
p.addParameter('collection',c,@isstruct);

p.parse(stdata,varargin{:});
stdata      = p.Results.stdata;
browse      = p.Results.browse;
collection  = p.Results.collection;
tab         = p.Results.tab;

%% Build the web URL

if isempty(stdata)
    % No st data sent in, so upon up the root project page
    url = sprintf('%s/#/projects',obj.url);
end

if isfield(collection,'id')
    % Show a session in the context of a collection.
    url = sprintf('%s/#/dashboard/collection/%s',obj.url,collection.id);
    % https://flywheel.scitran.stanford.edu/#/dashboard/collection/57117f9e981f740020aa8932/session/588bd1ac449f9800159305c2?tab=analysis
    
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

%% If there is a tab, attach it to the end

if ~isempty(tab)
    url = sprintf('%s?tab=%s',url,tab); 
end

%% Show, if requested

if browse, web(url,'-browser'); end

%%