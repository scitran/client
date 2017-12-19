function tbx = stToolbox(file,varargin)
% Initialize an array of toolboxes objects 
%
% Syntax
%   stToolbox(jsonFile)
%
% Description
%   The toolboxes class simplifies access to Matlab toolboxes stored on
%   github. The ability to retrieve a toolbox and test for its presence on
%   the user's path is contained in the information in a JSON toolboxes
%   file. Each such file may contain multiple entries for toolboxes. The
%   JSON data are read by this function, and the data are used to
%   initialize an array of scitran toolboxes objects.
%
% Input (required)
%   jsonFile - name of a JSON file, typically written by tbx.saveInfo, that
%              contains the github description of the repository, 
%           OR 
%              the struct returned by reading an appropriate JSON file
%
% Input (optional)
%   None
%
% Return
%   tbx - An array of toolboxes
%
% Example in code
%
% Wandell, Scitran, 2017
%
% See also: scitran.toolbox, scitran.getToolbox, scitran.toolboxValidate, s_tbxSave

% Example
%{
 tbx = stToolbox('test.json');
%}
%{
 s = jsonread('test.json');
 tbx = stToolbox(s);
%}

%% 
p = inputParser;
vFunc = @(x)(isstruct(x) || exist(x,'file') && isequal(x(end-4:end),'.json'));
p.addRequired('file',vFunc);
p.parse(file,varargin{:});

%% Read the file and create the toolboxes

if ischar(file),  tbxStruct = jsonread(file);
else,             tbxStruct = file;
end

for ii=1:numel(tbxStruct)
   tbx(ii) = toolboxes(''); %#ok<*AGROW>
   tbx(ii).testcmd = tbxStruct(ii).testcmd;
   tbx(ii).gitrepo = tbxStruct(ii).gitrepo;
end

end
