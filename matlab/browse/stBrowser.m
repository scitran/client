function url = stBrowser(sturl, obj, varargin)
% Open up the scitran URL to the object id
%
%  url = stBrowser(sturl, obj)
%
% Inputs:
%  sturl:       Scitran site url, say https://flywheel.scitran.stanford.edu
%  obj:         A struct returned by an stEsearchRun command.  We display
%               projects, sessions, acquisitions, and analyses.
%
% Optional parameter/value pairs
%  browse:     Bring up the browser (default is true)
%  collection:  Set to true to show a session from a collection
%
% Output:
%  url:    The url to a project or session or collection
%
% Examples:
%    stBrowse('https://flywheel.scitran.stanford.edu',obj,'browse',false);
%    stBrowse('https://flywheel.scitran.stanford.edu',obj,'collection',true);
%
% BW  Scitran Team, 2016

%% Parse the inputs
p = inputParser;

vFunc = @(x) isequal(x(1:5),'https');
p.addRequired('sturl',vFunc);

% The object is a returned search object from the stEsearchRun
% To use the browser, the object must be a project, session, acquisition,
% or analysis
vFunc = @(x) (isstruct(x) && ismember(x.type, {'projects','sessions','acquisitions','collections','analyses'}));
p.addRequired('obj',vFunc);

p.addParameter('browse',true,@islogical);

% If this exists, then it must be a struct.
c.c = false;
p.addParameter('collection',c,@isstruct);

p.parse(sturl,obj,varargin{:});
sturl      = p.Results.sturl;
obj        = p.Results.obj;
browse    = p.Results.browse;
collection = p.Results.collection;

%% Build and show the web URL

if isfield(collection,'id')
    % Show a session in the context of a collection.
    url = sprintf('%s/#/dashboard/collection/%s/session/%s',sturl,collection.id,obj.id);
else
    % We show a session, acquisition in the context of the project, not 
    switch obj.type
        
        case {'acquisitions'}
            % We show the session for an acquisition.
            url = sprintf('%s/#/dashboard/session/%s',sturl,obj.source.session);
        case {'analyses'}
            % Analyses are always part of a collection or session. If part
            % of a collection, we show the session within the collection.
            % The user must select the Analyses tab.  If part of a session,
            % we should do something else.  But not ready for that yet
            %
            % Not thoroughly debugged.
            url = sprintf('%s/#/dashboard/collection/%s',sturl,obj.source.container_id);
        otherwise
            % This is the case for a projects, sessions, collections in a project
            url = sprintf('%s/#/dashboard/%s/%s',sturl,obj.type(1:(end-1)),obj.id);
    end
end


if browse, web(url,'-browser'); end

%%