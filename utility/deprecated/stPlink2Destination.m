function destination = stPlink2Destination(pLink)
% Form an output file name from the permalink
%
% Required input
%   pLink - Either a permalink or a file{} struct
%
% Output
%   destination: A full path to a file
%
% Example:
%
% Wandell, Scitran Team, 2017

%% Probably should have an inputParse here

%%  If we sent in a files{} struct, then get the plink slot out now.
if isstruct(pLink), pLink = pLink.plink; end

%% Build the destination

% Combine permalink and username to generate the download link
% Handle permalinks which may have '?user=' elements
pLink = strsplit(pLink, '?');
pLink = pLink{1};

% Make the output file name
[~, f, e] = fileparts(pLink);
t_e = strsplit(e, '?');
out_dir = tempname;
mkdir(out_dir);
destination = fullfile(out_dir, [ f, t_e{1}]);

end
