% Script clones the scitran/jsonio directories and add them to your path
% BW, Scitran Team, 2017

fprintf('\n\n');
prompt = sprintf('Do you want to install into %s [Y/N]\n',pwd);
str = input(prompt,'s');

if isequal(lower(str),'y')
    thisDir = pwd;
    tst = which('scitran');
    if ~isempty(tst)
        warning('You appear to have scitran on your path.  Not downloading');
    else
        status = system('git clone https://github.com/scitran/client');
        if status, error('Problem cloning the scitran client repository'); end
        movefile('client','scitranClient');
    end
    
    tst = which('test_jsonread');
    if ~isempty(tst)
        warning('You appear to have jsonread on your path.  Not downloading.');
    else
        status = system('git clone https://github.com/gllmflndn/JSONio');
        if status, error('Problem cloning the JSONio repository'); end
        
        chdir('scitranClient'); addpath(genpath(pwd));
        chdir(thisDir); chdir('JSONio'); addpath(genpath(pwd));
    end
    chdir(thisDir);
    
    % Tell user where they are
    fprintf('\nscitranClient and JSONio toolboxes are installed in \n---\n \t %s\n---\n',thisDir);
else
    fprintf('User canceled installation.\n');
end

