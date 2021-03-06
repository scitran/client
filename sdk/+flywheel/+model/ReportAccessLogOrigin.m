% ReportAccessLogOrigin - The origin of a logged request (e.g. a user id)
%
% ReportAccessLogOrigin Properties:
%    type  - The origin type (e.g. user)
%    id    - The origin id (e.g. user id)
%
% ReportAccessLogOrigin Methods:
%    toJson - Convert the object to a Map that can be encoded to json
%    struct - Convert the object to a struct
    classdef ReportAccessLogOrigin < flywheel.ModelBase
    % NOTE: This file is auto generated by the swagger code generator program.
    % Do not edit the file manually.
    properties (Constant)
        propertyMap = containers.Map({ 'type', 'id' }, ...
            { 'type', 'id' });
    end
    properties(Dependent)
        type
        id
    end
    methods
        function obj = ReportAccessLogOrigin(varargin)
            obj@flywheel.ModelBase(flywheel.model.ReportAccessLogOrigin.propertyMap);

            % Allow empty object creation
            if length(varargin)
                p = inputParser;
                addParameter(p, 'type', []);
                addParameter(p, 'id', []);

                parse(p, varargin{:});

                if ~isempty(p.Results.type)
                    obj.props_('type') = p.Results.type;
                end
                if ~isempty(p.Results.id)
                    obj.props_('id') = p.Results.id;
                end
            end
        end
        function result = get.type(obj)
            if ismethod(obj, 'get_type')
                result = obj.get_type();
            else
                if isKey(obj.props_, 'type')
                    result = obj.props_('type');
                else
                    result = [];
                end
            end
        end
        function obj = set.type(obj, value)
            obj.props_('type') = value;
        end
        function result = get.id(obj)
            if ismethod(obj, 'get_id')
                result = obj.get_id();
            else
                if isKey(obj.props_, 'id')
                    result = obj.props_('id');
                else
                    result = [];
                end
            end
        end
        function obj = set.id(obj, value)
            obj.props_('id') = value;
        end
        function result = toJson(obj)
            result = containers.Map;
            if isKey(obj.props_, 'type')
                result('type') = flywheel.ModelBase.serializeValue(obj.props_('type'), 'char');
            end
            if isKey(obj.props_, 'id')
                result('id') = flywheel.ModelBase.serializeValue(obj.props_('id'), 'char');
            end
        end
        function result = struct(obj)
            result = struct;

            if isKey(obj.props_, 'type')
                result.type = obj.props_('type');
            else
                result.type = [];
            end
            if isKey(obj.props_, 'id')
                result.id = obj.props_('id');
            else
                result.id = [];
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
                if isKey(obj.props_, 'type')
                    propList.type = obj.props_('type');
                else
                    propList.type = [];
                end
                if isKey(obj.props_, 'id')
                    propList.id = obj.props_('id');
                else
                    propList.id = [];
                end
                prpgrp = matlab.mixin.util.PropertyGroup(propList);
            end
        end
    end
    methods(Static)
        function obj = fromJson(json, context)
            obj =  flywheel.model.ReportAccessLogOrigin;
            if isfield(json, 'type')
                obj.props_('type') = flywheel.ModelBase.deserializeValue(json.type, 'char');
            end
            if isfield(json, 'id')
                obj.props_('id') = flywheel.ModelBase.deserializeValue(json.id, 'char');
            end
            if isprop(obj, 'context_')
                obj.setContext_(context);
            end
        end
        function obj = ensureIsInstance(obj)
            if ~isempty(obj)
                % Realistically, we only convert structs
                if ~isa(obj, 'flywheel.model.ReportAccessLogOrigin')
                    obj = flywheel.model.ReportAccessLogOrigin(obj);
                end
                if isKey(obj.props_, 'type')
                end
                if isKey(obj.props_, 'id')
                end
            end
        end
    end
end
