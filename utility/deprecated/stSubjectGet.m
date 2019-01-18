function val = stSubjectGet(subjects,param)
% Get a field from a cell array of subjects
%
%  v = stSubjectsGet(subjects,'age');
%
%

n = length(subjects);

switch lower(param)
    case 'age'
        val = zeros(n,1);
        for ii=1:n
            val(ii) = subjects{ii}.age;
        end
        return
    case 'sex'
        val = blanks(n);
        for ii=1:n
            val(ii)  = subjects{ii}.sex(1);
        end

    case 'firstname'
        val = cell(n,1);
        for ii=1:n
            val{ii} = subjects{ii}.firstname;
        end
        return

    case 'lastname'
        val = cell(n,1);
        for ii=1:n
            val{ii} = subjects{ii}.lastname;
        end
        return

    case 'code'
        val = cell(n,1);
        for ii=1:n
            val{ii} = subjects{ii}.code;
        end
        return

    otherwise
        error('Unknown parameter %s\n',param);
end

end
