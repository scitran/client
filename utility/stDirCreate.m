function stDirCreate(d,varargin)
% Create an empty directory, d
%
% Syntax
%    stDirCreate(d,varargin)
%
% Description
%    Create a directory.  If it already exists, just return by
%    default.  But you may set a flag to empty an existing directory.
%
% Inputs
%   d:  The full path to the directory
%
% Optional key/val pairs
%   empty:  Empty the directory (default false)
%
% Returns
%   None
%
% LMP,BW Vistasoft Team, 2016
%
% See also
%

%% Parse inputs

p = inputParser;
p.addRequired('d',@ischar);
p.addParameter('empty',false,@islogical);
p.parse(d,varargin{:});
empty = p.Results.empty;

%% Check for existence.  

if exist(d,'dir') && empty
    % It already exists, but the empty flag is set.  So delete it and
    % remake it.
    rmdir(d, 's');
    mkdir(d);
elseif exist(d,'dir') && ~empty
    % Exists, but do not empty.  So just return.
    return;
else
    % Doesn't exist.  So make it
    mkdir(d);
end

end