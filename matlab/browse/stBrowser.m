function url = stBrowser(sturl, obj, varargin)
% Open up the scitran URL to the object id
%
%  url = stBrowser(sturl, obj)
%
% Input:
%  sturl:    Scitran site url, say https://flywheel.scitran.stanford.edu
%  obj:      A struct returned by an stEsearchRun command
%  display:  Bring up the browser (default is true)
%
% Output:
%  url:    The url to a project or session or collection
%
% Examples:
%    stBrowse('https://flywheel.scitran.stanford.edu',obj,'display',false);
%
% BW  Scitran Team, 2016

%% Parse the inputs
p = inputParser;

vFunc = @(x) isequal(x(1:5),'https');
p.addRequired('sturl',vFunc);

% The object is a returned search object from the stEsearchRun
p.addRequired('obj',@isstruct);

p.addParameter('display',true,@islogical);

p.parse(sturl,obj);
sturl = p.Results.sturl;
obj   = p.Results.obj;
display = p.Results.display;

%% Build and show the web URL

switch obj.type
    case {'acquisitions'}
        % Note that the session is referred to differently for acquisition
        % and files.  Not sure why
        url = sprintf('%s/#/dashboard/session/%s',sturl,obj.source.session);  
    case {'files'}
        % I think the container_id may be an acquisition, not a session.
        % So, it is likely we have to find the session that contains this
        % file.
        %         s.url = sturl; s.token = 'ya29.CjPXAqzlw9SzFD1cLnLNegce_fgdK3vz3i6P2iSnumlQif1B5yR0ilRfrXaEkp-Jy7Z-PWg';
        %         b.path = 'sessions'; b.sessions.match.container_id = obj.source.container_id;
        %         s.json = b;
        %         sessions = stEsearchRun(s);
        % Not sure how to get the session
        disp('browser not running yet for files')
        % url = stBrowser(sturl,sessions{1});
        % url = sprintf('%s/#/dashboard/session/%s',sturl,obj.source.container_id);
    otherwise
        % OK for projects and sessions and collections?
        url = sprintf('%s/#/dashboard/%s/%s',sturl,obj.type(1:(end-1)),obj.id);
end

if display, web(url,'-browser'); end

%%