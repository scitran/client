function destination = toolboxClone(st,tbx,varargin)
% Test for presence or install toolboxes from github
%
% Syntax
%    tbx = st.toolboxClone(tbx,...)
%
% Description
%  Clone an array of toolboxes from the github directories. After cloning,
%  the directories are added to the user's path.
%
% Input (required)
%  tbx:  An array of toolboxes
%
% Input (optional)
%   destination - Destination to place the repositories
%
% Output
%   destination - Destination containing the repositories
%
% Examples in code
%
% BW, Scitran Team, 2017
%
% See also toolboxes.install, scitran.toolboxGet

% st = scitran('stanfordlabs');
% Examples
%{
  tbx = toolboxes('WLVernierAcuity.json');
  st.toolboxClone(tbx,'destination',pwd);       
%}

%%
p = inputParser;

p.addRequired('tbx',@(x)(isa(x,'toolboxes')));
p.addParameter('destination',userpath,@(x)(exist(x,'dir')));
p.parse(tbx,varargin{:});

destination = p.Results.destination;

%% Do or don't install, using the toolboxes object install method

% If we install, the toolbox object checks if the path already contains the
% test function.  If not, then it installs from the github repository
% specified in the toolbox file structure.  
%
% Originally, we installed using git clone.  But going forward, we will
% probably create a tmp directory, download the zip file for each
% repository, and unzip them all into the tmp directory.  We will then add
% the tmp directory to the user's path.

nTbx = length(tbx);
for ii=1:nTbx
    if ~st.toolboxValidate(tbx(ii),'verbose',true)
        fprintf('Cloning %s from zip file\n',tbx(ii).gitrepo.project);
        tbx(ii).clone('destination',destination);
    end
end

end
