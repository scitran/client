function jQuery = stQueryCreate(varargin)
% Create the json data to send in the search query to a remote site
%
% This will greatly expand as we understand the possibilities
%
% Set up the json payload the we send to define the search.
%
% In this case
%  fields  - Which fields to search.  * means all.  'name' means name field
%  query   - String to search on
%  lenient - Things like allowing upper/lower case on the search
%
% We need a document on all the slots that we can fill.
%
%
%
% Example:
%  Default leniently looks for nii.gz files in any field
%   jQuery = stQueryCreate;
%
% LMP/BW Vistasoft Team


%% Parse
p = inputParser;
p.addParameter('fields','*',@ischar);
p.addParameter('query','.nii.gz',@ischar);
p.addParameter('lenient',true,@islogical);
p.parse(varargin{:});

fields  = p.Results.fields;
query   = p.Results.query;
lenient = p.Results.lenient;

%% Create

% Look in this field (label in this case; * means all fields)
jQuery.multi_match.fields  = fields;  
jQuery.multi_match.query   = query;   % The label we are looking for
jQuery.multi_match.lenient = lenient;

% Convert structure to json format
jQuery = savejson('', jQuery);

end
