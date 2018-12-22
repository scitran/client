function selected = stSelect(containers,slot,matchVal,varargin)
% Select containers from a cell array of containers that match a parameter
%
% Synopsis
%  selected = stSelect(container,slot,matchVal,varargin)
%
% Inputs
%  container - cell array of containers from a scitran.list
%  slot      - the slot that must be matched
%  matchVal  - String that the slot must match
%
% Optional key/value pairs
%  info field name, the info field value
%
% Returns
%  selected - The files that matched
%
%
% ZL/Wandell Vistasoft 2018
%
% See also
%   stPrint

% Examples:
%{
  stSelect(files,'type','archive','asset','car');
%}
%{
%}
%{
  stSelect(files,'name',filename);
%}

%% Parse inputs
p = inputParser;

p.addRequired('files',@iscell);
p.addRequired('slot',@ischar);
p.addRequired('matchVal',@ischar);
p.addParameter('infoval','',@ischar);

p.parse(containers,slot,matchVal); %,varargin{:});
matchVal = ieParamFormat(matchVal);

%%  Check if the file type and the critical info field matches the requirements

cnt = 1;
selected = {};
for jj = 1:length(containers)
    % Force the slot value to lower case and no spaces.
    try
        slotVal = ieParamFormat(containers{jj}.(slot));
    catch
        % If it doesn't exist, set it to empty.
        slotVal = '';
    end
    
    % See if the slot value matches
    if isequal(slotVal,matchVal)
        if isempty(varargin)
            % No info fields to check.
            selected{cnt} = containers{jj}; %#ok<AGROW>
            cnt = cnt + 1;
        else
            % There is also an info field specified.  Check that.
            try
                % Does the info field match?  This must be exact.
                if isequal(containers{jj}.info.(varargin{1}),varargin{2})
                    selected{cnt} = containers{jj}; %#ok<AGROW>
                    cnt = cnt + 1;
                end
            catch
                % Did not match
                disp('Seems to be a bad info field name %s\n',varargin{1});
            end
        end
    end
end