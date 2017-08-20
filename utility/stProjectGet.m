function val = stProjectGet(projects,param)
% Return a cell array with a specific field from a cell array of projects
%
%  stProjectGet(projCellArray,<param>);
%
% LMP, BW Scitran Team, 2017

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
