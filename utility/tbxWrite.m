function tbxWrite(filename,tbx)
% Write an array of toolbox objects into a json file
%
% Syntax
%   tbxWrite(filename,tbx)
%
% Inputs
%   filename - The output file name, a json file
%   tbx      - an array of toolboxes
%
% BW, Scitran Team, 2016

% Example:
%{
  tbx = toolboxes('vistasoft.json');
  tbxWrite('test.json',tbx);

  % Multiple toolboxes can also be written
  tbx(2) = toolboxes('jsonio.json');
  tbxWrite('test.json',tbx);
  test = jsonread('test.json')

  % This should come back as an array
  tbx = stToolbox('test.json');

%}

%% Parse and check

p = inputParser;
p.addRequired('filename',@(x)(ischar(x) && isequal(x(end-4:end),'.json')));
p.addRequired('tbx',@(x)(isequal(class(tbx(1)),'toolboxes')));
p.parse(filename,tbx);

%% Write it

jsonwrite(filename,tbx);

%%