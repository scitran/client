function destination = download(st,downloadType,ID,varargin)
%Download a tar file of a project or session or an acq or a collection
%
%    st.download(projectID,'destination','tarfile name');
%
% Inputs:
%   downloadType:  one of {'project','session','acquisition','collection'};
%   ID:  ID of the Flywheel data
%
% Parameters
%   destination:  Full path and name to the download file.  Default is
%                 fullfile(pwd,'download.tar');
%
% Only tested for projects at this point.
%
% BW Scitran Team, 2017

%% Check the download type, ID and set the destination

p = inputParser;

validTypes = {'project','session','acquisition','collection'};
p.addRequired('downloadType',@(x)(ismember(x,validTypes)));
p.addRequired('ID',@ischar);

p.addParameter('destination','download.tar',@ischar)

p.parse(downloadType,ID,varargin{:});
destination = p.Results.destination;

%% Build the Matlab struct for the download
clear payload
payload.optional      = true;
payload.nodes.level   = downloadType;
payload.nodes.x0x5Fid = ID;

% Convert the struct to JSON and format some annoying details
jPayload = jsonwrite(payload,struct('indent','  ','replacementstyle','hex'));
jPayload = regexprep(jPayload, '\n|\t', ' ');
jPayload = regexprep(jPayload, ' *', ' ');
jPayload = strrep(jPayload,'"nodes":','"nodes":[');
jPayload = strrep(jPayload,'" } ','" }] ');
        
% Get the ticket for the download
cmd = sprintf('curl ''%s/api/download'' -H ''Authorization: %s'' --data-binary ''%s''',st.url, st.showToken, jPayload);
[status, jTicket] = system(cmd);
if status, disp(jTicket); return; 
else,      sTicket = jsonread(jTicket);
end

%% Do the download, which is written to a tar file.

% This must happen within 1 minute of getting the ticket
cmd = sprintf('curl ''%s/api/download?ticket=%s'' > %s',st.url,sTicket.ticket,destination);
[status, result] = system(cmd);
if status, disp(result); end

untar(destination);

end
