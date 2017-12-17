function tbx = stToolbox(file,varargin)
% Initialize an array of toolboxes objects 
%
% Syntax
%   stToolbox(jsonFile)
%
% Description
%   The toolboxes simplify access to Matlab toolboxes stored on github. The
%   ability to retrieve a toolbox and test for its presence on the user's
%   path is contained in the information in a JSON toolboxes file. Each
%   such file may contain multiple entries for toolboxes. The JSON data are
%   read by this function, and the data are used to initialize an array of
%   scitran toolboxes objects.
%
% Input (required)
%   jsonFile - a JSON file, typically written by tbx.saveInfo, that
%              contains the github description of the repository
%
% Example in code
%
% Wandell, Scitran, 2017
%
% See also: s_tbxSave

% Example
%{
 tbx = stToolbox('test.json');
%}

%% 
p = inputParser;
p.addRequired('file',@(x)(exist(x,'file') && isequal(x(end-4:end),'.json')));
p.parse(file,varargin{:});

%% Read the file and create the toolboxes

tbxStruct = jsonread(file);

for ii=1:numel(tbxStruct)
   tbx(ii) = toolboxes(''); %#ok<*AGROW>
   tbx(ii).testcmd = tbxStruct(ii).testcmd;
   tbx(ii).gitrepo = tbxStruct(ii).gitrepo;
end

end
