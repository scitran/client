function val = stProjectGet(obj, projects,param)
% Get a field from a cell array returned by a search
%
%
%
% LMP,

n = length(projects);
if n < 1, warning('Empty project list'); return; end

% Determine the type of object returned.  From a search or list.
if isa(projects{1},'flywheel.model.SearchResponse'),     searchData = true;
elseif isa(projects{1},'flywheel.model.Project'),        searchData = false;
end

switch lower(param)
    case {'label', 'labels'}
        val = cell(n,1);
        if searchData
            for ii=1:n
                val{ii} = projects{ii}.project.label;
            end
        else
            % TODO
        end
    case 'group'
        val = blanks(n);
        for ii=1:n
            val(ii)  = projects{ii}.project.group.name;
        end
    case 'permissions'
        val = cell(n,1);
        for ii=1:n
            val{ii} = projects{ii}.project.user_permissions;
        end
    case {'numsessions', 'nsessions'}
        val = zeros(n,1);
        if searchData % Search data.
            for ii=1:n
                val(ii) = numel(obj.search('sessions', 'project id', projects{ii}.project.id));
            end
        else % List data.  We have the project id.
            for ii=1:n
                pSearch = obj.list('session',projects{ii}.id);
                val(ii) = numel(pSearch);
            end            
        end
        
    case 'id'
        val = cell(n,1);
        for ii=1:n
            val{ii} = projects{ii}.project.id;
        end
        
    otherwise
        error('Unknown parameter %s\n',param);
end

end



