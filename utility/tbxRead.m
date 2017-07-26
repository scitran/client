function tbx = tbxRead(filename)
% Read JSON file specifying toolboxes into an array of toolbox objects
%
% Example:
%   tbx(1) = toolboxes('file','vistasoft.json');
%   tbx(2) = toolboxes('file','jsonio.json');
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

%% Write it

tbxStruct = jsonread(filename);
for ii=length(tbxStruct):-1:1
    tbx(ii) = toolboxes;
    tbx(ii).testcmd = tbxStruct(ii).testcmd;
    tbx(ii).gitrepo = tbxStruct(ii).gitrepo;
end


end
%%