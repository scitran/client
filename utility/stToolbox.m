function tbx = stToolbox(file,varargin)
% Initialize an array of toolboxes
%
% Synatx
%   stToolbox(jsonFile)
%
% Read a JSON toolboxes file and initialize an array of toolboxes
%
% Wandell, Scitran, 2017

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
