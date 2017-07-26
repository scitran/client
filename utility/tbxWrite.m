function tbxWrite(filename,tbx)
% Write an array of toolbox objects into a json file
%
% Example:
%   tbx(1) = toolboxes('file','vistasoft.json');
%   tbx(2) = toolboxes('file','jsonio.json');
%   tbxWrite('test.json',tbx);
%
% Write the toolbox to a project annotation
%   fw = scitran('vistalab');
%
% 
%% Parse and check

p = inputParser;
p.addRequired('filename',@ischar);
p.addRequired('tbx',@(x)(isequal(class(tbx(1)),'toolboxes')));
p.parse(filename,tbx);

%% Write it

jsonwrite(filename,tbx);

%% Test the write
% foo = jsonread(filename);

%%