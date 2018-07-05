function [status, url, toolboxTable] = stFlywheelConfig(varargin)
% Check the status, install, or uninstall the Flywheel Add-On toolbox
%
% Syntax
%   [status, url, toolboxTable] = stFlywheelConfig( ...)
%
% Description
%   The Flywheel Add-Ons toolbox is necessary for scitran to run.  %
%   This function manages installation and uninstallation of the
%   toolbox.
%
%   The toolbox is placed in the user's 'Add-Ons' directory, usually
%   inside of fullfile(userpath,'Add-Ons');
%
%   The sdkVersion is used to identify the Add-On download release
%   from github.  Here is the link:
%   https://github.com/flywheel-io/core/releases 
%   
%
% Input
%   None required.  Defaults to 'exist'
%
% Optional Key/values
%   'exist':     Checks if the Add-On is there.  (Default)
%   'install'    Install a new Add-On toolbox
%   'uninstall'  Unstall an existing Add-On toolbox
%   'sdkVersion' Current is 2.4.3
%   'summary'    Print out a summary of the installed toolboxes
%
% Returns
%   status:  true or false depending on request
%   url:     URL to github of the mtlbx
%   toolboxTables - Table list of the installed Add-Ons toolboxes
%
% Installation instructions are here on the scitran wiki
%
%   https://github.com/scitran/client/wiki/Flywheel-SDK
%
% Simple examples
%    status = stFlywheelConfig;   % Test if add-on is installed
%    status = stFlywheelConfg('exist',true);  % Equivalent
%
%    status = stFlywheelConfig('uninstall',true);  % Uninstall
%    status = stFlywheelConfig('install',true);    % Download and install
%
% BW, Vistasoft, 2018

%Examples:
%{
  status = stFlywheelConfig('exist',true);
%}
%{
  status = stFlywheelConfig;
%}
%{
  [s,u,tbl] = stFlywheelConfig('install',true,'sdkVersion','2.4.3');
%}
%{
  stFlywheelConfig('uninstall',true);
%}

%%
p = inputParser;
varargin = stParamFormat(varargin);
p.addParameter('install',false,@islogical);
p.addParameter('uninstall',false,@islogical);
p.addParameter('exist',false,@islogical);
p.addParameter('sdkversion','2.4.3',@ischar);
p.addParameter('summary',true,@islogical);

p.parse(varargin{:});

% Check for logical constancy.
install    = p.Results.install;
uninstall  = p.Results.uninstall;
exist      = p.Results.exist;
sdkVersion = p.Results.sdkversion;
summary    = p.Results.summary;

% Only one of these can be set.  If none is set, we check for the existence
% on the path.
if (install + uninstall + exist) == 0
    exist = true;
elseif (install + uninstall + exist ) ~= 1
    error('Choose only one of the options.  exist (%d), uninstall (%d) install (%d)',...
        exist,uninstall,install);
end

%% Do the selected task

% This is the most recent toolbox file
tbxFile = sprintf('flywheel-sdk-%s.mltbx',sdkVersion);
url = sprintf('https://github.com/flywheel-io/core/releases/download/%s/flywheel-sdk-%s.mltbx',sdkVersion,sdkVersion);

if exist
    % Checks that the flywheel-sdk is installed in the Add-Ons    
    tbx = matlab.addons.toolbox.installedToolboxes;
    if numel(tbx) >= 1
        for ii=1:numel(tbx)
            if isequal(tbx(ii).Name,'flywheel-sdk')
                % flywheelTbx = tbx(ii);
                try
                    % This would be preferred, but doesn't run on
                    % 2017a.  It does on 2017b.
                    status = matlab.addons.isAddonEnabled(flywheelTbx.Guid);
                catch
                    % Just set it true because it exists
                    status = true;
                end
            end
        end
    else, status = false;
    end

elseif install
    % Download from Flywheel and install
    fprintf('Installing the Flywheel Add-Ons toolbox: %s\n',tbxFile);
    cd(fullfile(stRootPath,'local'));
    % websave(tbxFile,'https://github.com/flywheel-io/core/releases/download/2.1.4/flywheel-sdk-2.1.4.mltbx');
    websave(tbxFile,'https://github.com/flywheel-io/core/releases/download/2.4.3/flywheel-sdk-2.4.3.mltbx');

    matlab.addons.toolbox.installToolbox(tbxFile);
    
    % We might decide to verify here
    status = stFlywheelConfig('exist',true);
    if ~status
        warning('Installation problem');
        return;
    end
    
    % Then delete the downloaded file
    delete(tbxFile);

elseif uninstall
    try
        matlab.addons.toolbox.uninstallToolbox('flywheel-sdk');
    catch
        toolboxes = matlab.addons.toolbox.installedToolboxes;
        for ii=1:length(toolboxes)
            if toolboxes(ii).Name == 'flywheel-sdk'
                matlab.addons.toolbox.uninstallToolbox(toolboxes(ii));
                break;
            end
        end
    end
end

if summary
    toolboxes = matlab.addons.toolbox.installedToolboxes;
    if isempty(toolboxes)
        fprintf('No Add-On toolboxes\n');
    elseif isfield(toolboxes(1),'Name')
        toolboxTable = struct2table(toolboxes);
    else
        disp(toolboxes(1));
    end
end

end

