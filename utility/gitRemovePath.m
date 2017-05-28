function newPathList = gitRemovePath(pathList,dName)
% Removes .git directories from the pathList.
%
%   newPathList = gitRemovePath(pathList)
%
% This is typically run during startup or when adding a git repository to
% the path.
%
% pathList:   The paths. If no pathList is specified, then the program sets
%             pathList to the result of the 'path' command. 
% dName:      The directory name for removal.  If none is set, this
%             defaults to .git
%
% Example:
%    gitRemovePath;
%
%    p = path; dName = '.git';
%    newPathList = gitRemovePath(p,dName);
%
% History:
% 14.07.06 Written by Christopher Broussard.
% 25.07.06 Modified to work on M$-Windows and GNU/Octave as well (MK).
% 31.05.09 Adapted to fully work on Octave-3 (MK).
% 18.12.10 Ported to ISET, changing the defaults and updating (BW)
% 24.04.13 Converted to GIT from svn (BW)
%
% BW Scitran Team, 2017

if ~exist('pathList','var') || isempty('pathList'), pathList = path; end
if ~exist('dName','var')    || isempty('dName'), dName = '.git'; end

% Break the path list into individual path elements.
pathElements = textscan(pathList, '%s', 'delimiter', pathsep);

% Look at each element from the path.  If it doesn't contain a .svn folder
% then we add it to the end of our new path list.
newPathList = [];
for ii = 1:length(pathElements)
    if isempty(strfind(pathElements{ii}, [filesep dName]))
        newPathList = [newPathList, pathElements{ii}, pathsep]; %#ok<AGROW>
    % else fprintf('Removing %s\n',pathElements{ii});
    end
end

% Drop the last path separator if the new path list is non-empty.
if ~isempty(newPathList)
    newPathList = newPathList(1:end-1);
end

% I don't know why we need to call path(path).  But we do.
path(newPathList); path(path)

end
