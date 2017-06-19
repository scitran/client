% Script clones the scitran/jsonio directories and add them to your path
% BW, Scitran Team, 2017

fprintf('\n\n');
prompt = sprintf('Do you want to install into %s [Y/N]\n',pwd);
str = input(prompt,'s');

if isequal(lower(str),'y')
    thisDir = pwd;
    tst = which('scitran');
    if ~isempty(tst)
        fprintf('scitran is on your path at %s.\nNo git clone performed.\n\n',fileparts(tst));
    else
        fprintf('git cloneing scitran/client.\n');
        status = system('git clone https://github.com/scitran/client');
        if status, error('Problem cloning the scitran client repository'); end
        fprintf('Moving scitran/client to scitranClient.\n');
        status = movefile('client','scitranClient');
        if status ~= 1
            chdir(thisDir);
            error('Error during move\n');
        end
        chdir('scitranClient'); addpath(genpath(pwd));
        chdir(thisDir);
    end
    
    tst = which('jsonread');
    if ~isempty(tst)
        fprintf('jsonread is on your path at %s.\nNo git clone performed.\n\n',fileparts(tst));
    else
        fprintf('git cloneing JSONio\n');
        status = system('git clone https://github.com/gllmflndn/JSONio');
        if status, error('Problem cloning the JSONio repository'); end
        
        chdir('JSONio'); addpath(genpath(pwd));
        chdir(thisDir);

    end
    
    % Tell user where they are
    fprintf('\nSummary: scitranClient and JSONio toolboxes are installed in \n---\n \t %s\n---\n',thisDir);
else
    fprintf('User canceled installation.\n');
end

