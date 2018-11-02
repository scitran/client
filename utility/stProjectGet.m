function val = stProjectGet(obj, projects,param)
% Get a field from a cell array returned by a search 
%
%  
%
% LMP, 

n = length(projects);

switch lower(param)
    case {'label', 'labels'}
        val = cell(n,1);
        for ii=1:n
            val{ii} = projects{ii}.project.label;
        end
        return
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
        return
        
    case {'numsessions', 'nsessions'}
        val = zeros(n,1);
        for ii=1:n
            val(ii) = numel(obj.search('sessions', 'project label exact', projects{ii}.project.label));
        end
        return;
        
    case 'id'
        val = cell(n,1);
        for ii=1:n
            val{ii} = projects{ii}.project.id;
        end
        return
        
    otherwise
        error('Unknown parameter %s\n',param);
end

end
