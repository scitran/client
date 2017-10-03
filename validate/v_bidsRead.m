%% v_bidsRead
%
% Tests reading the BIDS-Examples directories.
%
% You need to have the BIDS-Examples github repository on your system.  We
% expect that it is in your local/BIDS-Examples directory.
%
%   b = bids(bidsDir);
%
% We need to find other tests, say v_bidsLoad of the files or something.
%
% BW, Scitran Team, 2017

%% Here is an example bids data set

dirList = {'ds001','ds002','ds005','ds006','ds007','ds008',...
    'ds009','ds011','ds051','ds052',...
    'ds101','ds102','ds105','ds107',...
    'ds108','ds109','ds110','ds113b','ds114','ds116','7t_trt'};
fprintf('Testing %d directories\n',length(dirList));

%%
for ii=1:length(dirList)
    fprintf('\n\nDirectory %s ***\n',dirList{ii});
    bidsDir = fullfile(stRootPath,'local','BIDS-Examples',dirList{ii});
    b = bids(bidsDir);
    b.validate;
    disp(b)
end

%%
