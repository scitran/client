function selectedFiles = stFileSelect(files,slot,matchVal,varargin)
% Select files from a cell array of files based on a parameter
%
% Inputs
%  files - cell array of files from a list
%  slot  - the slot that must match
%  matchVal - What the slot must match
%
% Optional key/value pairs
%    info field name, the info field value
%
% Returns
%  keepFiles - The files that matched
%
% ZL/Wandell Vistasoft 2018

% Examples:
%{
  stFileSelect(files,'type','archive','asset','car');
%}
%{
  stFileSelect(files,'name',filename);
%}

%%
p = inputParser;
p.addRequired('files',@iscell);
p.addRequired('slot',@ischar);
p.addRequired('matchVal',@ischar);

p.parse(files,slot,matchVal); %,varargin{:});

%%  Check if the file type and the critical info field matches the requirements

cnt = 1;
selectedFiles = {};
for jj = 1:length(files)
    if isequal(files{jj}.(slot),matchVal)
        if isempty(varargin)
            % Have a match.  No info fields to check.
            selectedFiles{cnt} = files{jj}; %#ok<AGROW>
            cnt = cnt + 1;
        else
            % Check the info field specified by varargin
            try
                % Does the info field match?
                if isequal(files{jj}.info.(varargin{1}),varargin{2})
                    selectedFiles{cnt} = files{jj}; %#ok<AGROW>
                    cnt = cnt + 1;
                end
            catch
                % Did not match
                disp('No info field match');
            end
        end
    end
end