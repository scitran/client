function url = stBrowser(sturl,obj, varargin)
% Open up the scitran URL to the object id
%
%  url = stBrowser(sturl,obj)
%
% Input:
%  sturl:    Scitran site url, say https://flywheel.scitran.stanford.edu
%  obj:      A struct returned by an stEsearchRun command
%  display:  Bring up the browser (default is true)
%
% Output:
%  url:    The url 
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
url = sprintf('%s/#/dashboard/%s/%s',sturl,obj.x0x5F_type(1:(end-1)),obj.x0x5F_id);

if display, web(url,'-browser'); end

%%