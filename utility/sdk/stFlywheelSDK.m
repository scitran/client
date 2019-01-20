function status = stFlywheelSDK(action)
% Check the status of the Flywheel-SDK
%
% Syntax
%   status = stFlywheelSDK(action)
%
% Description
%   This function tests the installation of the Flywheel-SDK and reports on
%   the version number.
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
%   'action'  - One of the following strings
%
%      'verify'    - Tests whether the Flywheel-SDK is installed
%      'releases'  - Opens a web browser to the page of releases
%      'installed version' - Returns an integer number describing the
%         installed version.  This is the three numbers in sdkNNN of your
%         scitran branch.
%      'single use' - When running the SDK in a Gear, we want to be able to
%                     create a single use key that is provided by the
%                     Flywheel system. 
%
% Output
%   status   - Integer describing the SDK version installed in this
%              scitran branch
%
% BW, Vistasoft, 2018
%
% See also
%   scitran.verify


%Examples:
%{
  status = stFlywheelSDK('verify');
%}
%{
  status = stFlywheelSDK('releases');
%}
%{
  versionNumber = stFlywheelSDK('installed version');
%}

%%
p = inputParser;
p.addRequired('action',@ischar);

p.parse(action);

action     = stParamFormat(p.Results.action);

%% Do the selected task

switch action
    case {'verify'}
        % Checks that the flywheel-sdk is installed in the Add-Ons
        
        % Probably incorporated into scitran
        sdkPath = which('flywheel.Flywheel');
        if isempty(sdkPath)
            disp('No flywheel SDK found');
            status = false;
        else
            sdk = split(sdkPath,'sdk');
            sdkVer = sdk{2}(1:3);
            fprintf('Verified installed version %s\n',sdkVer);
            status = sdkVer;
        end
        
    case 'singleuse'
        error('Single use is not yet implemented');
        
    case {'releases'}
        status = 'https://github.com/flywheel-io/core/releases';
        web(status,'-browser');
        
    case {'installedversion'}
        % Returns an integer corresponding to this Add-On version
        
        % Probably incorporated into scitran
        sdkPath = which('flywheel.Flywheel');
        if isempty(sdkPath)
            disp('No flywheel SDK found');
            status = false;
        else
            sdk = split(sdkPath,'sdk');
            sdkVer = sdk{2}(1:3);
            fprintf('Verified installed version %s\n',sdkVer);
            status = str2double(sdkVer);
        end

    otherwise
        error('Unknown action: %s\n',action);
end

end

