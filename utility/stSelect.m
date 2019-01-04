function selected = stSelect(containers,slot,matchVal,varargin)
% Select containers from a cell array of containers that match a parameter
%
% Syntax:
%  selected = stSelect(container,slot,matchVal,varargin)
%
% Inputs
%  container - cell array of containers from a scitran.list
%  slot      - the slot that must be matched
%  matchVal  - String that the slot must match (contains, by default)
%
% Optional key/value pairs
%  contains - Boolean to use contains matchVal rather than exact match
%  infoval  - Fields within the info slot to check
%
% Returns
%  selected - The files that matched
%
% ZL/Wandell Vistasoft 2018
%
% See also
%   stPrint

% Examples:
%{
  % stSelect(files,'type','archive','asset','car');
%}
%{
  % stSelect(files,'name',filename);
%}

%% Parse inputs
p = inputParser;

varargin = stParamFormat(varargin);

p.addRequired('files',@iscell);
p.addRequired('slot',@ischar);
p.addRequired('matchVal',@ischar);

p.addParameter('contains',true,@logical);    % Contains or Exact match.
p.addParameter('infoval','',@ischar);        % Info field to match
p.addParameter('infofield','',@ischar);      % Info field value to match

p.parse(containers,slot,matchVal,varargin{:}); %,varargin{:});

matchVal   = ieParamFormat(matchVal);
contains   = p.Results.contains;
infoField  = p.Results.infofield;
infoVal    = p.Results.infoval;

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
    
    if contains  % 
        if stContains(slotVal,matchVal)
            if isempty(infoField)
                % No info fields to check.
                selected{cnt} = containers{jj}; %#ok<AGROW>
                cnt = cnt + 1;
            else
                % There is also an info field specified.  Check that.
                try
                    % Does the info field match?
                    if stContains(containers{jj}.info.(infoField),infoVal)
                        selected{cnt} = containers{jj}; %#ok<AGROW>
                        cnt = cnt + 1;
                    end
                catch
                    % Did not match
                    disp('Bad info field name %s\n',varargin{1});
                end
            end
        end
        
    else         % Exact match
        
        % See if the slot value matches
        if isequal(slotVal,matchVal)
            if isempty(infoField)
                % No info fields to check.
                selected{cnt} = containers{jj}; %#ok<AGROW>
                cnt = cnt + 1;
            else
                % There is also an info field specified.  Check that.
                try
                    % Does the info field match?  This must be exact.
                    if isequal(containers{jj}.info.(infoField),infoVal)
                        selected{cnt} = containers{jj}; %#ok<AGROW>
                        cnt = cnt + 1;
                    end
                catch
                    % Did not match
                    disp('Bad info field name %s\n',varargin{1});
                end
            end
        end
    end
    
end