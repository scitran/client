%% This is a scratch file for integration with github
%
% I am trying to understand how we might get individual files, or perhaps
% the zip file of a repository, for github.
% This would be a better substitute (git the zip, unzip, add to path) than
% cloning the repository
%
% BW Scitran Team, 2017

%%  This is particular good for reproducible commit downloads
% I haven't been able to make it work.  Probably not understanding the
% syntax.
%
%See
% https://stackoverflow.com/questions/13636559/how-to-download-zip-from-github-for-a-particular-commit-sha/18472043

filename = 'test.zip';
url = 'https://github.com/isetbio/WLVernierAcuity/master.zip'
websave(filename,url);

url = 'https://github.com/wandell/isetbio/WLVernierAcuity/fa1f7b0b4349d8be4620c29ca002bcf8620952dd.zip'
websave(filename,url);


%% This worked for me for a file
url = 'https://raw.githubusercontent.com/isetbio/isetbio/master/isettools/data/images/rgb/Ma_BurchellZebra_627.jpg'
filename = 'test.jpg';
websave(filename,url);


%%
url = 'http://heritage.stsci.edu/2007/14/images/p0714aa.jpg';
filename = 'jupiter_aurora.jpg';
outfilename = websave(filename,url)