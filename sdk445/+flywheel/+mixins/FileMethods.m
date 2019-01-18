classdef FileMethods < handle
    methods
        function result = get_files(obj)
            % Get without loading
            result = obj.get('files');
            for i = 1:numel(result)
                result{i}.parent_ = obj;
            end
        end
        function result = getFiles(obj)
            % Get the list of container files, loading if necessary
            result = obj.get('files');
            if isempty(result) && ~isempty(obj.get('id'))
                tmp = obj.reload();
                result = tmp.get('files');
            end
            for i = 1:numel(result)
                result{i}.parent_ = obj;
            end
        end
        function result = getFile(obj, name)
            % Get the first file entry with the given name, loading if necessary
            files = obj.getFiles();
            for i = 1:numel(files)
                if strcmp(files{i}.name, name)
                    result = files{i};
                    break
                end
            end
        end
        function result = fileRef(obj, name)
            % Get a reference to the given file
            file = obj.getFile(name);
            if ~isempty(file)
                result = file.ref();
            else
                result =[];
            end
        end
        function [returnData, resp] = uploadFile(obj, file)
            [returnData, resp] = obj.invokeContainerApi('uploadFileTo%s', obj.get('id'), file);
        end
        function [returnData, resp] = downloadFile(obj, fileName, destFile, varargin)
            [returnData, resp] = obj.invokeContainerApi('downloadFileFrom%s', obj.get('id'), fileName, destFile, varargin{:});
        end
        function [returnData, resp] = getFileDownloadUrl(obj, fileName)
            [returnData, resp] = obj.invokeContainerApi('get%sDownloadUrl', obj.get('id'), fileName);
        end
        function [returnData, resp] = readFile(obj, fileName, varargin)
            [returnData, resp] = obj.invokeContainerApi('downloadFileFrom%sAsData', obj.get('id'), fileName, varargin{:});
        end
        function [returnData, resp] = updateFile(obj, fileName, varargin)
            body = flywheel.mixins.ContainerBase.structFromArgs(varargin);
            [returnData, resp] = obj.invokeContainerApi('modify%sFile', obj.get('id'), fileName, body);
        end
        function [returnData, resp] = deleteFile(obj, fileName)
            [returnData, resp] = obj.invokeContainerApi('delete%sFile', obj.get('id'), fileName);
        end
        function [returnData, resp] = replaceFileInfo(obj, fileName, info)
            [returnData, resp] = obj.invokeContainerApi('replace%sFileInfo', obj.get('id'), fileName, info);
        end
        function [returnData, resp] = updateFileInfo(obj, fileName, varargin)
            body = flywheel.mixins.ContainerBase.structFromArgs(varargin);
            [returnData, resp] = obj.invokeContainerApi('set%sFileInfo', obj.get('id'), fileName, body);
        end
        function [returnData, resp] = deleteFileInfo(obj, fileName, keys)
            [returnData, resp] = obj.invokeContainerApi('delete%sFileInfoFields', obj.get('id'), fileName, keys);
        end
        function [returnData, resp] = replaceFileClassification(obj, fileName, varargin)
            p = inputParser;
            addParameter(p, 'modality', []);
            addParameter(p, 'classification', []);
            parse(p, varargin{:});

            body = flywheel.model.ClassificationUpdateInput('replace', p.Results.classification, 'modality', p.Results.modality);
            [returnData, resp] = obj.invokeContainerApi('modify%sFileClassification', obj.get('id'), fileName, body);
        end
        function [returnData, resp] = updateFileClassification(obj, fileName, classification)
            [returnData, resp] = obj.invokeContainerApi('set%sFileClassification', obj.get('id'), fileName, classification);
        end
        function [returnData, resp] = deleteFileClassification(obj, fileName, classification)
            [returnData, resp] = obj.invokeContainerApi('delete%sFileClassificationFields', obj.get('id'), fileName, classification);
        end
    end
end
