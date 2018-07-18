function selectedFiles = stFileSelect(files,slot,matchVal)
% Routine to select files from a cell array of files based on a
% parameter
%
% Inputs
%  files - cell array of files from a list
%  slot  - the slot that must match
%  matchVal - What the slot must match
%
% Returns
%  keepFiles - The files that matched
%
%
% Wandell

cnt = 1;
selectedFiles = {};
for jj = 1:length(files)
    if isequal(files{jj}.(slot),matchVal)
        selectedFiles{cnt} = files; %#ok<AGROW>
        cnt = cnt + 1;
    end
end

end