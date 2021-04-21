function help(~,src)
% Open up a wiki help page.
%
% Syntax:
%    scitran.help(helpOption)
%
% Inputs
%   helpOption: 'wiki','sdk release','sdk examples','sdk package','help'
%
% Optional key/value
%   N/A
%
% Returns
%   N/A - A web page is displayed in your browser
%
% Wandell, SCITRAN Team, 2018
%
% See also
%

% Examples:
%{
  st = scitran('stanfordlabs');
  st.help('help');

  st.help;     % Wiki
  st.help('wiki');

  st.help('sdk starting');
  st.help('sdk examples');
  st.help('sdk releases');
  st.help('sdk package');

%}

%%
if notDefined('src'), src = 'help'; end
src = stParamFormat(src);
webOptions = {'wiki','sdk releases','sdk starting','sdk examples','sdk package','help'};

%% Bring up the help pages

%{
% Older URLs.  Maybe they will reappear?
% url = 'https://flywheel-io.github.io/core/branches/master/matlab/getting_started.html';
% url = 'https://github.com/flywheel-io/core/releases';
% url = 'https://flywheel-io.github.io/core/branches/master/matlab/examples.html';
% url = 'https://flywheel-io.github.io/core/branches/master/matlab/flywheel.html';
%}

switch(src)
    case 'wiki'
        url = 'https://github.com/scitran/client/wiki';
    case 'sdkstarting'
        url = 'https://flywheel-io.gitlab.io/product/backend/sdk/branches/master/matlab/index.html';
    case 'sdkreleases'
        url = 'https://flywheel-io.gitlab.io/product/backend/sdk/branches/master/matlab/getting_started.html#introduction';
    case 'sdkexamples'
        url = 'https://flywheel-io.gitlab.io/product/backend/sdk/branches/master/matlab/getting_started.html';
    case 'sdkpackage'
        url = 'https://flywheel-io.gitlab.io/product/backend/sdk/branches/master/matlab/getting_started.html#introduction'; 
    otherwise
        % help brings this up
        fprintf('st.help(Parameter)\nParameter options \n');
        for ii=1:length(webOptions)
            fprintf('   %s\n',webOptions{ii});
        end
        fprintf('\n');
        return;
end

% Bring up the web page
web(url,'-browser')

end