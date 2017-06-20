## Installing from the terminal

You can install this scitranClient and another essential toolbox, Guillaume Flandin's code to read and write JSON files (JSONio) by 

    git clone https://github.com/scitran/client
    git clone https://github.com/gllmflndn/JSONio
    
This will create two directories, client and JSONio.  We suggest renaming the 'client' directory 'scitranClient'.  Please add both directories to your path, say by using

    chdir(<scitran client directory>); addpath(genpath(pwd));
    chdir(<JSONio directory>); addpath(genpath(pwd));

## Installing from Matlab (alternative)

```
fprintf('\n\n');
prompt = sprintf('Do you want to install into %s [Y/N]\n',pwd);
str = input(prompt,'s');

if isequal(lower(str),'y')
    thisDir = pwd;
    status = system('git clone https://github.com/scitran/client');
    if status, error('Problem cloning the scitran client repository'); end
    movefile('client','scitranClient');
    
    status = system('git clone https://github.com/gllmflndn/JSONio');
    if status, error('Problem cloning the JSONio repository'); end
    
    chdir('scitranClient'); addpath(genpath(pwd));
    chdir(thisDir); chdir('JSONio'); addpath(genpath(pwd));
    
    chdir(thisDir);
    
    % Tell user where they are
    fprintf('\nscitranClient and JSONio toolboxes are installed in \n---\n \t %s\n---\n',thisDir);
else
    fprintf('User canceled installation.\n');
end
```