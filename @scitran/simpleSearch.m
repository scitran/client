function [results, srch] = simpleSearch(stClient,searchReturn,varargin)
% SIMPLESEARCH - Simple search interface for common requests
%
% What should we do about exact matches or partial matches?
%
% Examples:
%  The sessions in a project for a specific subject
%   r = st.simpleSearch('sessions','project','VWFA_NIMS','subject','ex13642');
%
%  The files in a project by a particular subject
%   r = st.simpleSearch('files','project','VWFA_NIMS','subject','ex13642');
%
%  The acquisitions in a project for a subject 
%   r = st.simpleSearch('acquisitions','project','VWFA_NIMS','subject','ex13642');
%
%  The acquisitions in a project containing 'T1' in the label
%   r = st.simpleSearch('acquisitions','project','VWFA_NIMS','acquisition label contains','T1');
%
%  The acquisitions in a project containing matchign a specific label
%   r = st.simpleSearch('acquisitions','project','VWFA_NIMS','acquisition label exact','6_1_fMRI_Ret_knk');
% 
%  The sessions with a label in a project
%   r = st.simpleSearch('sessions','project label','VWFA_NIMS','session label','20151128_1621');
%
% TODO
%    * The 'contains' isn't going well
%    * Need a strategy for multiple contraints when we need bool.must
%    method
%    * Need simpler and more examples
%
% BW,RA,RF SCITRAN Team

%%
p = inputParser;
p.KeepUnmatched = true;

vFunc = @(x)(ismember(x,{'files','sessions','acquisitions','projects'}));
p.addRequired('searchType',vFunc);

p.parse(searchReturn);

% Make sure length of varargin is even
if mod(length(varargin),2)
    error('Must have an even number of param/val varargin');
end

%% The type of object we return
srch.path = searchReturn;

% Build the search structure from the param/val pairs
n = length(varargin);
for ii=1:2:n
    val = varargin{ii+1};
    
    % Force lower and remove blanks
    sformatted = strrep(lower(varargin{ii}),' ','');

    switch stParamFormat(sformatted)
        case 'sessionlabel'
            srch.sessions.match.label = val;
        case 'sessionid'
            srch.sessions.match.x0x5F_id = val;
        case {'projectlabel','project'}
            srch.projects.match.label = val;
        case {'acquisitionlabelcontains'}
            srch.acquisitions.match.label = val;
        case {'acquisitionlabelexact','acquisitionlabel'}
            srch.acquisitions.match.exact_label = val;
        case {'filename'}
            srch.files.match.name = val;
        case {'subjectcode'}
            srch.sessions.match.subjectx0x2E_code = val;
        otherwise
    end
end

%% Do the search

% For debugging, here is the json string
% jsonSearch = jsonwrite(srch,struct('indent','  ','replacementstyle','hex')) 

results = stClient.search(srch);

end
%%