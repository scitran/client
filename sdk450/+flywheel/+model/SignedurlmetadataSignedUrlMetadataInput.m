% SignedurlmetadataSignedUrlMetadataInput
%
% SignedurlmetadataSignedUrlMetadataInput Properties:
%    metadata 
%    filename 
%
% SignedurlmetadataSignedUrlMetadataInput Methods:
%    toJson - Convert the object to a Map that can be encoded to json
%    struct - Convert the object to a struct
    classdef SignedurlmetadataSignedUrlMetadataInput < flywheel.ModelBase
    % NOTE: This file is auto generated by the swagger code generator program.
    % Do not edit the file manually.
    properties (Constant)
        propertyMap = containers.Map({ 'metadata', 'filename' }, ...
            { 'metadata', 'filename' });
    end
    properties(Dependent)
        metadata
        filename
    end
    methods
        function obj = SignedurlmetadataSignedUrlMetadataInput(varargin)
            obj@flywheel.ModelBase(flywheel.model.SignedurlmetadataSignedUrlMetadataInput.propertyMap);

            % Allow empty object creation
            if length(varargin)
                p = inputParser;
                addParameter(p, 'metadata', []);
                addParameter(p, 'filename', []);

                parse(p, varargin{:});

                if ~isempty(p.Results.metadata)
                    obj.props_('metadata') = p.Results.metadata;
                end
                if ~isempty(p.Results.filename)
                    obj.props_('filename') = p.Results.filename;
                end
            end
        end
        function result = get.metadata(obj)
            if ismethod(obj, 'get_metadata')
                result = obj.get_metadata();
            else
                if isKey(obj.props_, 'metadata')
                    result = obj.props_('metadata');
                else
                    result = [];
                end
            end
        end
        function obj = set.metadata(obj, value)
            obj.props_('metadata') = value;
        end
        function result = get.filename(obj)
            if ismethod(obj, 'get_filename')
                result = obj.get_filename();
            else
                if isKey(obj.props_, 'filename')
                    result = obj.props_('filename');
                else
                    result = [];
                end
            end
        end
        function obj = set.filename(obj, value)
            obj.props_('filename') = value;
        end
        function result = toJson(obj)
            result = containers.Map;
            if isKey(obj.props_, 'metadata')
                result('metadata') = obj.props_('metadata').toJson();
            end
            if isKey(obj.props_, 'filename')
                result('filename') = flywheel.ModelBase.serializeValue(obj.props_('filename'), 'char');
            end
        end
        function result = struct(obj)
            result = struct;

            if isKey(obj.props_, 'metadata')
                result.metadata = struct(obj.props_('metadata'));
            else
                result.metadata = [];
            end
            if isKey(obj.props_, 'filename')
                result.filename = obj.props_('filename');
            else
                result.filename = [];
            end
        end
        function result = returnValue(obj)
            result = obj;
        end
    end
    methods(Access = protected)
        function prpgrp = getPropertyGroups(obj)
            if ~isscalar(obj)
                prpgrp = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
            else
                propList = struct;
                if isKey(obj.props_, 'metadata')
                    propList.metadata = obj.props_('metadata');
                else
                    propList.metadata = [];
                end
                if isKey(obj.props_, 'filename')
                    propList.filename = obj.props_('filename');
                else
                    propList.filename = [];
                end
                prpgrp = matlab.mixin.util.PropertyGroup(propList);
            end
        end
    end
    methods(Static)
        function obj = fromJson(json, context)
            obj =  flywheel.model.SignedurlmetadataSignedUrlMetadataInput;
            if isfield(json, 'metadata')
                obj.props_('metadata') = flywheel.model.AnalysisInput.fromJson(json.metadata, context);
            end
            if isfield(json, 'filename')
                obj.props_('filename') = flywheel.ModelBase.deserializeValue(json.filename, 'char');
            end
            if isprop(obj, 'context_')
                obj.setContext_(context);
            end
        end
        function obj = ensureIsInstance(obj)
            if ~isempty(obj)
                % Realistically, we only convert structs
                if ~isa(obj, 'flywheel.model.SignedurlmetadataSignedUrlMetadataInput')
                    obj = flywheel.model.SignedurlmetadataSignedUrlMetadataInput(obj);
                end
                if isKey(obj.props_, 'metadata')
                    obj.props_('metadata') =  flywheel.model.AnalysisInput.ensureIsInstance(obj.props_('metadata'));
                end
                if isKey(obj.props_, 'filename')
                end
            end
        end
    end
end