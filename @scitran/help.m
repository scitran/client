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

  st.help('sdk examples');
  st.help('sdk releases');
  st.help('sdk package');

%}

%%
if notDefined('src'), src = 'help'; end
src = stParamFormat(src);
webOptions = {'wiki','sdk releases','sdk examples','sdk package','help'};

%% Bring up the help pages

switch(src)
    case 'wiki'
        url = 'https://github.com/scitran/client/wiki';
    case 'sdkreleases'
        url = 'https://github.com/flywheel-io/core/releases';
    case 'sdkexamples'
        url = 'https://flywheel-io.github.io/core/branches/master/matlab/examples.html';
    case 'sdkpackage'
        url = 'https://flywheel-io.github.io/core/branches/master/matlab/flywheel.html#';
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