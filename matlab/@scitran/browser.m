function url = browser(obj, stdata, varargin)
% Open up the scitran URL to the object id
%
%  url = stBrowser(obj, dType, varargin)
%
% Inputs:
%  stdata:    A struct returned by an st.search command.  We display
%             projects, sessions, acquisitions, and analyses.
%
% Optional parameter/value pairs
%  browse:      Bring up the browser (default is true)
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

% The object is a returned search object from the stEsearchRun
% To use the browser, the object must be a project, session, acquisition,
% or analysis
vFunc = @(x) (isstruct(x) && ismember(x.type, {'projects','sessions','acquisitions','collections','analyses'}));
p.addRequired('stdata',vFunc);

% Bring up the browser window
p.addParameter('browse',true,@islogical);

% If this exists, then it must be a struct.
c.c = false;
p.addParameter('collection',c,@isstruct);

p.parse(stdata,varargin{:});
stdata      = p.Results.stdata;
browse      = p.Results.browse;
collection  = p.Results.collection;

%% Build and show the web URL

if isfield(collection,'id')
    % Show a session in the context of a collection.
    url = sprintf('%s/#/dashboard/collection/%s/session/%s?tab=data',obj.url,collection.id,stdata.id);
else
    % We show a session, acquisition in the context of the project, not 
    switch stdata.type
        
        case {'acquisitions'}
            % We show the session for an acquisition.
            url = sprintf('%s/#/dashboard/session/%s',ob.url,stdata.source.session);
        case {'analyses'}
            % Analyses are always part of a collection or session. If part
            % of a collection, we show the session within the collection.
            % The user must select the Analyses tab.  If part of a session,
            % we should do something else.  But not ready for that yet
            %
            % Not thoroughly debugged.
            url = sprintf('%s/#/dashboard/collection/%s',obj.url,stdata.source.container.x0x5F_id);
        otherwise
            % This is the case for a projects, sessions, collections in a project
            url = sprintf('%s/#/dashboard/%s/%s',obj.url,stdata.type(1:(end-1)),stdata.id);
    end
end


if browse, web(url,'-browser'); end

%%