function tbx = toolbox(st,fileStruct,varargin)
% Install toolboxes for a script or function in a scitran instance
%
%    tbx = st.toolbox(fileStruct,'install',logical)
%
% Required input
%   fileStruct:  This is either a plink or a struct defining the toolbox JSON
%                file on the scitran site.
%
% Optional input:
%   install:  Boolean on whether to execute toolboxes.install (default: true)
%
% Output
%   tbx - the toolboxes object
%
% Example:
%   st = scitran('action', 'create', 'instance', 'scitran');
%   tbxFile = st.search('files','project label contains','Diffusion Noise','file name','toolboxes.json');
%   tbx = st.toolbox(tbxFile{1},'install',false);
%
% BW, Scitran Team, 2017

%%
p = inputParser;

vFunc = @(x)(isstruct(x) || ischar(x));
p.addRequired('fileStruct',vFunc);

p.addParameter('install',true, @islogical);

p.parse(fileStruct,varargin{:});
install = p.Results.install;

%%
tbx = toolboxes('scitran',st,'file',fileStruct);

% Could become optional
if install, tbx.install; end

end

%% 