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
  st.help;     % Wiki
  st.help('wiki');

  st.help('sdk examples');
  st.help('sdk releases');
  st.help('sdk package');

%}

%%
if notDefined('src'), src = 'wiki'; end
src = ieParamFormat(src);
webOptions = {'wiki','sdk releases','sdk examples','sdk package','help'};

%% Bring up the help pages

switch(src)
    case 'wiki'
        web('https://github.com/scitran/client/wiki','-browser')
    case 'sdkreleases'
        web('https://github.com/flywheel-io/core/releases','-browser')
    case 'sdkexamples'
        web('https://flywheel-io.github.io/core/branches/master/matlab/examples.html','-browser');
    case 'sdkpackage'
        web('https://flywheel-io.github.io/core/branches/master/matlab/flywheel.html#','-browser')
    case 'help'
        fprintf('\n');
        tbl = cell2table(webOptions);
        disp(tbl);
        fprintf('\n');
    otherwise
        fprintf('Unknown help option: %s\nOptions are:\n\n',src);
        tbl = cell2table(webOptions);
        disp(tbl);
        fprintf('\n');
end

end