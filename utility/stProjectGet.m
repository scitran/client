function val = stProjectGet(obj, projects,param)
% Get a field from a cell array of projects
%
%
%

n = length(projects);

switch lower(param)
    case {'label', 'labels'}
        val = cell(n,1);
        for ii=1:n
            val{ii} = projects{ii}.source.label;
        end
        return
    case 'group'
        val = blanks(n);
        for ii=1:n
            val(ii)  = projects{ii}.source.group.name;
        end
        
    case 'permissions'
        val = cell(n,1);
        for ii=1:n
            val{ii} = projects{ii}.source.user_permissions;
        end
        return
        
    case {'numsessions', 'nsessions'}
        val = zeros(n,1);
        for ii=1:n
            val(ii) = numel(obj.search('sessions', 'project label', projects{ii}.source.label));
%             fprintf('%s : %d\n', projects{ii}.source.label, val(ii));
        end
        return
    case 'id'
        val = cell(n,1);
        for ii=1:n
            val{ii} = projects{ii}.id;
        end
        return
        
    otherwise
        error('Unknown parameter %s\n',param);
end

end
