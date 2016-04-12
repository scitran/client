%% Testing of search, print, ...
%
file = fullfile(sdmRootPath,'local','scitranData.mat');
load(file)
d = scitranData;

%% First, create some cell arrays and return the index


lst = sdmPrint(d,'subject code');

lst = sdmPrint(d,'file name');

idx = sdmSearch(d,'pField','subject code','value','ex8403')

%%