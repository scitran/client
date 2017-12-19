function destination = toolboxInstall(st,tbx,varargin)
% Install array of toolboxes using zip files downloaded from github
%
% Syntax
%  destination = st.toolboxInstall(tbx,...)
%
% Description
%  Install an array of toolboxes from a downloaded zip file of the
%  repository. After installation, the directories are added to the user's
%  path.
%
% Input (required)
%  tbx:  An array of toolboxes
%
% Input (optional)
%  destination:  Full path to directory to contain the toolbox 
%
% Output
%   tbx - an array of toolboxes objects
%
% See also:  s_stToolboxes, s_tbxSave, scitran.toolboxGet
%
% Examples in code
%
% BW, Scitran Team, 2017
%
% See also toolboxes.clone, scitran.toolboxGet

% st = scitran('vistalab');
% Examples
%{
  % Installs from a zip file
   tbx = toolboxes('WLVernierAcuity.json');
   st.toolboxInstall(tbx,'destination',pwd);
%}

%%
p = inputParser;

p.addRequired('tbx',@(x)(isa(x,'toolboxes')));
p.addParameter('destination',userpath,@(x)(exist(x,'dir')));
p.parse(tbx,varargin{:});
destination = p.Results.destination;

%% Do or don't install, using the toolboxes object install method

% Check if the path contains the test function.  If not, install by
% downloading a zip file from the github repository.
nTbx = length(tbx);
for ii=1:nTbx
    if ~st.toolboxValidate(tbx(ii),'verbose',true)
        fprintf('Installing %s from zip file\n',tbx(ii).gitrepo.project);
        tbx(ii).install('destination',destination);
    else
        fprintf('Test command is on your path (%s)\n',which(tbx(ii).testcmd));
    end
end

end

%% 