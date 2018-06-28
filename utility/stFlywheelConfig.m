function status = stFlywheelConfig(varargin)
% Check the status, install, or uninstall the Flywheel Addon
%
% Syntax
%   status = stFlywheelConfig( ...)
%
% Description
%   Manage the Flywheel Add-Ons toolbox on the user's
%   path.  This toolbox is necessary for scitran to run.  The toolbox is
%   placed in the user's 'Add-Ons' directory, usually inside of
%   fullfile(userpath,'Add-Ons');
%
%
% Optional Key/values
%   exist:  Default
%   install:
%   uninstall
%
% Returns
%   status:  true or false depending on request
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
  stFlywheelConfig('install',true);
%}
%{
  stFlywheelConfig('uninstall',true);
%}

%%
p = inputParser;
p.addParameter('install',false,@islogical);
p.addParameter('uninstall',false,@islogical);
p.addParameter('exist',false,@islogical);
p.parse(varargin{:});

% Check for logical constancy.
install   = p.Results.install;
uninstall = p.Results.uninstall;
exist     = p.Results.exist;

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
tbxFile = 'flywheel-sdk-2.1.4.mltbx';

if exist
    % Checks that the flywheel-sdk is installed in the Add-Ons    
    tblAddons = matlab.addons.installedAddons;
    identifier = tblAddons.Identifier(tblAddons.Name == 'flywheel-sdk');
    status = matlab.addons.isAddonEnabled(identifier);

elseif install
    % Download from Flywheel and install
    fprintf('Installing the Flywheel Add-Ons toolbox: %s\n',tbxFile);
    cd(fullfile(stRootPath,'local'));
    websave(tbxFile,'https://github.com/flywheel-io/core/releases/download/2.1.4/flywheel-sdk-2.1.4.mltbx');
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
    % Should we check?  What if there are multiple?
    matlab.addons.toolbox.uninstallToolbox('flywheel-sdk');

end

end

