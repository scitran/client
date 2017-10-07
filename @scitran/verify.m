function status = verify(obj)
% Search for number of projects, mainly to verify that the APIkey works
%
%   status = st.verify;
%
% Examples:
%
%   st = scitran('vistalab');
%   if ~st.verify,  error('Bad scitran key, or no projects.'); end
%   
% % Returns a 1 if verified, 0 otherwise.
%   status = st.verify
%
% BW Scitran team, 2017

try
    status = obj.fw.testBridge('world!');
    %     searchStruct.return_type = 'project';
    %     results = obj.search(searchStruct);
    %     if ~isempty(results), status = 1; end
catch ME
    % It is possible status doesn't get returned in this case.
    rethrow(ME)
end

end
