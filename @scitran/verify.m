function nProjects = verify(obj)
% Search for number of projects, mainly to verify that the APIkey works
%
%   nProjects = scitran.verify;
%
% Example:
%
%   if ~scitran.verify,  error('Bad scitran key, or no projects.'); end
%
% BW Scitran team, 2017

try
    searchStruct = struct('return_type', 'project');
    results = obj.fw.search(searchStruct).results;
    nProjects = length(results);
catch ME
    rethrow(ME)
end

end
