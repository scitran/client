function structFromJson = handleJson(obj,statusPtr,ptrValue)
% Handle JSON using JSONlab
statusValue = statusPtr;

% If status indicates success, load JSON
if statusValue == 0
    % Interpret JSON string blob as a struct object
    loadedJson = loadjson(ptrValue);
    % loadedJson contains status, message and data, only return
    %   the data information.
    dataFromJson = loadedJson.data;
    %  Call replaceField on loadedJson to replace x0x5F_id with id
    structFromJson = Flywheel.replaceField(dataFromJson,'x0x5F_id','id');
    % Otherwise, nonzero statusCode indicates an error
else
    % Try to load message from the JSON
    try
        loadedJson = loadjson(ptrValue);
        msg = loadedJson.message;
        ME = MException('FlywheelException:handleJson', msg);
        % If unable to load message, throw an 'unknown' error
    catch ME
        msg = sprintf('Unknown error (status %d).',statusValue);
        causeException = MException('FlywheelException:handleJson', msg);
        ME = addCause(ME,causeException);
        rethrow(ME)
    end
    throw(ME)
end
end