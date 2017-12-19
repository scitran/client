function tbxPrint(tbx)
% Print a summary of an array of toolboxes
%
% Syntax
%   tbxPrint(tbx)
%
% Description
%   Reads the fields and prints a convenient summary of the toolbox
%   specifications.
%
% Input (required)
%  tbx - Array of toolboxes
% Input (optional)
%  None
% Return
%  None
%
% BW, Vistasoft team, 2017
%
% See also:  tbxRead, tbxWrite, scitran.toolboxValidate

%{
tbx = st.toolboxGet('aldit-toolboxes.json',...
    'project','ALDIT');
tbxPrint(tbx);
%}

%% 
p = inputParser;
p.addRequired('tbx',@(x)(isa(x,'toolboxes')));
p.parse(tbx);

%%
nTbx = numel(tbx);

for ii=1:nTbx
    fprintf('\nToolbox %d\n',ii)
    fprintf('-------------\n')

    fprintf('Toolbox project name %s\n',tbx(ii).gitrepo.project);
    fprintf('User account: %s\n',tbx(ii).gitrepo.user);
    fprintf('Commit:  %s\n',tbx(ii).gitrepo.commit);    
    url = sprintf('https://github.com/%s/%s',tbx(ii).gitrepo.user,tbx(ii).gitrepo.project); 
    fprintf('Repository url:  %s\n',url);
    
    fprintf('-------------\n')
    cmd = which(tbx(ii).testcmd);
    fprintf(' %s',tbx(ii).testcmd);
    if isempty(cmd), fprintf(' is not on your current path.\n')
    else
        repoDirectory = fileparts(cmd);
        fprintf(' is on your current path in directory %s.\n',repoDirectory);
    end
    fprintf('\n\n')

end
