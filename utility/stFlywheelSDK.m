function [status, url, toolboxTable] = stFlywheelSDK(action,varargin)
% Check the status, install, or uninstall the Flywheel Add-On toolbox
%
% Syntax
%   [status, url, toolboxTable] = stFlywheelSDK(action, ...)
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
%   'action'  - install, uninstall or exist. Defaults to 'exist'
%
% Optional Key/values
%   'sdkVersion' Current is 4.1.0 (Nov. 1, 2018)
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
%    status = stFlywheelSDK;   % Test if add-on is installed
%    status = stFlywheelSDK('exist');  % Equivalent
%
%    status = stFlywheelSDK('uninstall');  % Uninstall
%
%    % Restart MATLAB
%    status = stFlywheelSDK('install');    % Download and install
%
% BW, Vistasoft, 2018
%
% See also
%

%Examples:
%{
  status = stFlywheelSDK('exist');
%}
%{
  [status,url,toolboxTable] = stFlywheelSDK('exist');
%}
%{
  [s,u,tbl] = stFlywheelSDK('install','sdkVersion','4.1.0');
%}
%{
  stFlywheelSDK('uninstall');
%}

%%
p = inputParser;
varargin = stParamFormat(varargin);
p.addRequired('action',@ischar);
p.addParameter('sdkversion','4.1.0',@ischar);
p.addParameter('summary',true,@islogical);

p.parse(action,varargin{:});

action     = p.Results.action;
sdkVersion = p.Results.sdkversion;
summary    = p.Results.summary;

%% Do the selected task

% This is the most recent toolbox file
tbxFile = sprintf('flywheel-sdk-%s.mltbx',sdkVersion);
url = sprintf('https://github.com/flywheel-io/core/releases/download/%s/flywheel-sdk-%s.mltbx',sdkVersion,sdkVersion);

switch action
    case {'verify','exist'}
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
        
    case 'install'
        % Download from Flywheel and install
        fprintf('Installing the Flywheel Add-Ons toolbox: %s\n',tbxFile);
        cd(fullfile(stRootPath,'local'));
        websave(tbxFile,url);
        
        matlab.addons.toolbox.installToolbox(tbxFile);
        
        % We might decide to verify here
        status = stFlywheelSDK('exist');
        if ~status
            warning('Installation problem');
            return;
        end
        
        % Then delete the downloaded file
        delete(tbxFile);
        
    case 'uninstall'
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
        disp(toolboxes(1));
    end
end

end

