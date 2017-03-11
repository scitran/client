function results = simpleSearch(stClient,searchReturn,varargin)
% SIMPLESEARCH - Simple search interface for the most common requests
%
% What should we do about exact matches or partial matches?
%
% Example:
%  st = scitran('action', 'create', 'instance', 'scitran');
%  st.simpleSearch('files','session label','Label')
%  r = st.simpleSearch('sessions','project label','VWFA');
%  r = st.simpleSearch('sessions','session label','20151128_1621','project label','VWFA');
%
% BW, SCITRAN Team

%%
p = inputParser;
p.KeepUnmatched = true;
vFunc = @(x)(ismember(x,{'files','sessions','acquisitions','projects'}));
p.addRequired('searchType',vFunc);

p.parse(searchReturn,varargin{:});

srch.path = searchReturn;

%% Add in the other stuff
n = length(varargin);
for ii=1:2:n
    val = varargin{ii+1};
    switch stParamFormat(varargin{ii})
        case 'sessionlabel'
            srch.sessions.match.label = val;
        case 'projectlabel'
            srch.projects.match.label = val;
        otherwise
    end
end

%
results = stClient.search(srch);


end
%%