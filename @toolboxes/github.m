function url = github(obj,varargin)
% Open up the browser to the github site
%
% Syntax
%   tbx.github(...)
%
% Description
%  Use the information in the tbx object to open the browser to the github
%  page.  Could be the code or the wiki page.  
%
% Input (required)
%   
% Input (optional)
%   page -  {wiki,issues,projects,pulls,settings}
%
% Return
%
% Example
%   tbx(2).github
%   tbx(1).github('page','issues');
%
%
% Wandell, Vistasoft Team, 2017

%%
p = inputParser;
p.addParameter('page','',@ischar);

p.parse(varargin{:});
page = p.Results.page;

%% Build the url and open
url = sprintf('https://github.com/%s/%s',obj.gitrepo.user,obj.gitrepo.project);

if ~isempty(page)
    url = sprintf('%s/%s',url,page);
end

web(url,'-browser');


end
%%