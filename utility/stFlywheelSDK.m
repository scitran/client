function [status, flywheelTbx, toolboxTable] = stFlywheelSDK(action,varargin)
% Check the status, install, or uninstall the Flywheel Add-On toolbox
%
% Syntax
%   [status,  toolboxTable] = stFlywheelSDK(action, ...)
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
%   from github.  Here is the link to the releases.
%
%         https://github.com/flywheel-io/core/releases 
%   
% Input
%   'action'  - The variable action is one of the following strings
%      'verify'    - Tests whether the toolbox is installed
%      'install'   - Install the matlab toolbox add-on
%      'uninstall' - Unstall the matlab toolbox add-on
%      'releases'  - Opens a web browser to the page of releases
%      'installed version' - Returns a number describiing installed
%                    version in your Matlab Add-Ons.  Returned as an
%                    integer with all the '.' removed from version string.
%      'single use' - When running the SDK in a Gear, we want to be able to
%                     create a single use key that is provided by the
%                     Flywheel system. 
%
% Optional Key/values
%   'sdk version'    - Release version you want to install (current is
%                         4.3.2 (Dec. 1, 2018))
%   'summary'        - Print out a summary of the installed toolbox
%
% Returns
%   status        - true or false depending on presence of Toolbox
%   flywheelTbx   - The flywheel toolbox Add-On
%
% Installation instructions are here on the scitran wiki
%
%   https://github.com/scitran/client/wiki/Flywheel-SDK
%
%   % See your current status
%   status = stFlywheelSDK('verify');   % Test if add-on is installed
%   stFlywheelSDK('verify','summary',true);  % Print info
%
%   % Uninstall current system
%   status = stFlywheelSDK('uninstall');  % Uninstall
%   status = stFlywheelSDK('verify'); 
%
%   % Restart MATLAB
%
%   % Install a new version
%   status = stFlywheelSDK('install','sdkVersion','4.3.2');    % Download and install
%
% BW, Vistasoft, 2018
%
% See also
%
% Comment from DHB
%{
P.S. I also figured out how to get rid of something unwanted on the
static java class path, which may already be well known to others. 
=> At Matlab prompt: 
    a) cd(prefdir) 
    b) edit javaclasspath.txt 
    c) delete the lines you don?t want and save 
    d) restart Matlab.  
%}

%Examples:
%{
  status = stFlywheelSDK('verify');
%}
%{
  [status,flywheelTbx] = stFlywheelSDK('verify');
%}
%{
  [s,u,tbl] = stFlywheelSDK('install','sdkVersion','4.3.2');
%}
%{
  stFlywheelSDK('uninstall');
%}
%{
  stFlywheelSDK('releases');
%}
%{
  versionNumber = stFlywheelSDK('installed version');
%}

%%
p = inputParser;
varargin = stParamFormat(varargin);
p.addRequired('action',@ischar);
p.addParameter('sdkversion','4.3.2',@ischar);
p.addParameter('summary',false,@islogical);

p.parse(action,varargin{:});

action     = stParamFormat(p.Results.action);
sdkVersion = p.Results.sdkversion;
summary    = p.Results.summary;

status = false;   % In case it is not set below.

%% Do the selected task

% This is the most recent toolbox file
tbxFile = sprintf('flywheel-sdk-%s.mltbx',sdkVersion);
url = sprintf('https://github.com/flywheel-io/core/releases/download/%s/flywheel-sdk-%s.mltbx',sdkVersion,sdkVersion);

switch action
    case {'verify'}
        % Checks that the flywheel-sdk is installed in the Add-Ons
        flywheelTbx = [];
        tbx = matlab.addons.toolbox.installedToolboxes;
        if numel(tbx) >= 1
            for ii=1:numel(tbx)
                if isequal(tbx(ii).Name,'flywheel-sdk')
                    flywheelTbx = tbx(ii);
                    try
                        % This would be preferred, but doesn't run on
                        % 2017a.  It does on 2017b.
                        status = matlab.addons.isAddonEnabled(flywheelTbx.Guid);
                    catch
                        % Just set it true because it exists
                        status = true;
                    end
                    fprintf('Verified installed version: %s\n',tbx(ii).Version);
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
        status = stFlywheelSDK('verify');
        if ~status
            warning('Installation problem');
            return;
        end
        
        % Then delete the downloaded file
        delete(tbxFile);
        
    case 'singleuse'
        error('Single use is not yet implemented');
        
    case 'uninstall'
        try
            status = matlab.addons.toolbox.uninstallToolbox('flywheel-sdk');
        catch
            toolboxes = matlab.addons.toolbox.installedToolboxes;
            for ii=1:length(toolboxes)
                if toolboxes(ii).Name == 'flywheel-sdk'
                    matlab.addons.toolbox.uninstallToolbox(toolboxes(ii));
                    break;
                end
            end
        end
        
    case {'releases'}
        disp('SDK Releases')
        web('https://github.com/flywheel-io/core/releases','-browser');
        
    case {'installedversion'}
        % Returns an integer corresponding to this Add-On version
        [~, flywheelTbx] = stFlywheelSDK('verify');
        if isempty(flywheelTbx)
            fprintf('No Flywheel SDK Add-ON found\n');
            status = false;
        else
            status = str2double(strrep(flywheelTbx.Version,'.',''));
        end
    otherwise
        error('Unknown action: %s\n',action);
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

