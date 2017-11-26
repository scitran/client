function tbx = tbxRead(filename)
% Read JSON file specifying toolboxes into an array of toolbox objects
%
% Example:
%   tbx(1) = toolboxes('vistasoft.json');
%   tbx(2) = toolboxes('jsonio.json');
%   tbxWrite('test.json',tbx);
%   tbx = tbxRead('test.json');
%
% Write the toolbox to a project annotation
%   fw = scitran('vistalab');
%
% 
%% Parse and check

p = inputParser;
p.addRequired('filename',@(x)(exist(x,'file')));
p.parse(filename);

%% Read the json file and fill in the struct

tbxStruct = jsonread(filename);

tbx = toolboxes('');
tbx.testcmd = tbxStruct.testcmd;
tbx.gitrepo = tbxStruct.gitrepo;

end

