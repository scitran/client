function userInfo = verify(obj,varargin)
% Search for number of projects, mainly to verify that the APIkey works
%
%   userInfo = st.verify;
%
% Returns
%   status:   1 if verified, 0 otherwise.
%   userInfo: Structured returned by fw.getCurrentUser method
%
% BW Scitran team, 2017
%
% See also
%   scitran

% Examples:
%{
  st = scitran('stanfordlabs');
  if ~st.verify,  error('Bad scitran key, or no projects.'); 
  else, disp('verified');
  end
%}
%{
  st = scitran('stanfordlabs');
  st.verify('verbose',true);
%}

%%
p = inputParser;
p.addRequired('obj',@(x)(isa(x,'scitran')));

p.addParameter('verbose',true,@islogical);    % Print out
p.addParameter('esearch',false,@islogical);   % Test elastic search
p.addParameter('connection',true,@islogical); % Verify connection

p.parse(obj,varargin{:});
verbose = p.Results.verbose;
esearch = p.Results.esearch;
connection = p.Results.connection;

%%
try
    userInfo = obj.fw.getCurrentUser;
    if isempty(userInfo), status = 0; 
    else,                 status = 1;
    end
    
    if status == 0
        warning('Connection not verified.  Empty userInfo');
        return;
    end
    
    if verbose && status && connection == 1
        sdk = stFlywheelSDK('installed version');
        fprintf('Connection verified. SDK version %d\n',sdk);
        
        % Proceed through additional verifications
        if esearch
            % Test that elastic search is working
            groups = obj.groups;
            groupL = groups{1}.label;
            projectL = 'eSearchTest';
            
            % Create the eSearchTes project
            id = obj.containerCreate(groupL,projectL);
            
            % Pause for indexing, and then test that search finds the project
            pause(3);
            p = obj.search('project','project id',id.project);
            if isempty(p)
                % Give another chance
                pause(3);
                p = obj.search('project','project id',id.project);
            end
            
            if isempty(p)
                % Declare failure
                fprintf('Elastic search failed after 6 seconds.\n');
            else
                % Declare victory and delete the project
                fprintf('Elastic search found the new project\n');
                obj.containerDelete(p{1});
            end
            
        end
        
    elseif verbose
        fprintf('Connection NOT verified\n');
    end

catch ME
    % It is possible status doesn't get returned in this case.
    rethrow(ME)

end


end
