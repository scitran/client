% Script clones the scitran/jsonio directories and add them to your path
% BW, Scitran Team, 2017

fprintf('\n\n');

%% Test for toolboxes

disp('Checking for toolboxes...');

% Test for jsonio
tstr = which('jsonread');
if ~isempty(tstr)
    fprintf('jsonread is on your path at %s.\n',fileparts(tstr));
    installJsonio = false;
else
    installJsonio = true;
end

%test for client
tst = which('scitran');
if ~isempty(tst)
    fprintf('scitran is on your path at %s.\n\n',fileparts(tst));
    installClient = false;
else
    installClient = true;
end

%% Handle the installation

if installClient || installJsonio

    prompt = sprintf('\nOne or more required toolboxes were not found.\n\nDo you want to install into %s [Y/N]\n',pwd);
    str = input(prompt,'s');

    if isequal(lower(str),'y')

        % Check for git installation
        status = system('which git');
        if status ~= 0; warning('Git is not installed or not on your path'); return; end

        thisDir = pwd;
        if installClient
            fprintf('git cloning scitran/client.\n');
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

        if installJsonio
            fprintf('git cloning JSONio\n');
            status = system('git clone https://github.com/gllmflndn/JSONio');
            if status ~= 0; error('Problem cloning the JSONio repository'); end

            chdir('JSONio'); addpath(genpath(pwd));
            chdir(thisDir);
        end

        % Tell user where they are
        fprintf('\nSummary: Required toolboxes were installed and added to your path \n---\n\t%s\n---\n', thisDir);
    else
        fprintf('User canceled installation.\n');
    end
else
    disp('Required toolboxes were found. Nothing to do!');
end

