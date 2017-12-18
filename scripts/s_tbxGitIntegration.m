%% This is a scratch file for integration with github
%
% It turns out we can get individual files and even zip files corresponding
% to the specific sha of a commit to the repository.
%
% I think getting the zip files, putting them in a directory, adding the
% whole directory to the user's path, would be a better than the clone we
% do of the repository.
%
% Also, we can use websave to get individual files rather than the 'html'
% wrapper by using the githubusercontent https: address below.
%
% BW Scitran Team, 2017

%%  This is particular good for reproducible commit downloads
%
%See
% https://stackoverflow.com/questions/13636559/how-to-download-zip-from-github-for-a-particular-commit-sha/18472043

url = 'https://github.com/isetbio/WLVernierAcuity/archive/fa1f7b0b4349d8be4620c29ca002bcf8620952dd.zip';
filename = 'test.zip';
websave(filename,url);

%% To get the latest and greatest, not a specific commit, ...

% Parameters are 
% https://github.com/{username}/{projectname}/archive/{sha or master}.zip
url = 'https://github.com/isetbio/WLVernierAcuity/archive/master.zip';

% Whatever you name the download file, when unzip'd the directory becomes
% WLVernierAcuity-{sha or master}
filename = 'WlVernierAcuity-master.zip';
outfilename = websave(filename,url);
if exist(outfilename,'file')
    unzip(outfilename);
end

%% This worked for me for a file
url = 'https://raw.githubusercontent.com/isetbio/isetbio/master/isettools/data/images/rgb/Ma_BurchellZebra_627.jpg';
filename = 'test.jpg';
websave(filename,url);


%% An example from the Mathworks web page.

url = 'http://heritage.stsci.edu/2007/14/images/p0714aa.jpg';
filename = 'jupiter_aurora.jpg';
outfilename = websave(filename,url);

%%