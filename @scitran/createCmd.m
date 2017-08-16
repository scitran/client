function cmd = createCmd(obj, containerType, payload, varargin)
% Build the command to create a project/session/acquisition
%
%     @scitran.createCmd
%
% Used by @scitran.create
%
% Default was changed so that the new entity inherits the group permissions.
%
% RF/BW Scitran Team, 2016

%% Programming note - Email from LMP
%
% I should mention that I got clarity from Megan about the default group permissions. 
% The URL must be modified to inherit group permissions. 
% In that one instance (creating a project) the URL must end 
% with ?inherit=true (which is called a query param). 


%% Parse
p = inputParser;
p.addRequired('containerType',@ischar);
p.addRequired('payload',@ischar);
p.addParameter('inheritance',true,@islogical);

p.parse(containerType, payload, varargin{:});

containerType      = p.Results.containerType;
payload            = p.Results.payload;
inheritance        = p.Results.inheritance;

%% Make the command

if inheritance
    cmd = sprintf('curl -s -XPOST "%s/api/%s?inherit=true" -H "Authorization":"%s" -k -d ''%s''',...
        obj.url, containerType, obj.token, payload);
else
    cmd = sprintf('curl -s -XPOST "%s/api/%s" -H "Authorization":"%s" -k -d ''%s''',...
        obj.url, containerType, obj.token, payload);
end

cmd = regexprep(cmd, '\n|\t', ' ');
cmd = regexprep(cmd, ' *', ' ');

end


