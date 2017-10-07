function newStruct = replaceField(~,oldStruct,oldField,newField)
% Replace a field within a struct or a cell array of structs
% Check if variable is a cell
if iscell(oldStruct)
    % Initialize newStruct as a copy of the oldStruct
    newStruct = oldStruct;
    for k=1:length(oldStruct)
        f = fieldnames(oldStruct{k});
        % Check if oldField is a fieldname in oldStruct
        if any(ismember(f, oldField))
            [oldStruct{k}.(newField)] = oldStruct{k}.(oldField);
            newStruct{k} = rmfield(oldStruct{k},oldField);
        else
            newStruct{k} = oldStruct{k};
        end
    end
    % Check if variable is a struct
elseif isstruct(oldStruct)
    % Replace a fieldname within a struct object
    f = fieldnames(oldStruct);
    % Check if oldField is a fieldname in oldStruct
    if any(ismember(f, oldField))
        [oldStruct.(newField)] = oldStruct.(oldField);
        newStruct = rmfield(oldStruct,oldField);
    else
        newStruct = oldStruct;
    end
    % If not, newStruct is equal to oldStruct
else
    newStruct = oldStruct;
end
end