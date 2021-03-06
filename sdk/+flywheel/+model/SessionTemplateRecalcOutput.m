% SessionTemplateRecalcOutput
%
% SessionTemplateRecalcOutput Properties:
%    sessionsChanged 
%
% SessionTemplateRecalcOutput Methods:
%    toJson - Convert the object to a Map that can be encoded to json
%    struct - Convert the object to a struct
    classdef SessionTemplateRecalcOutput < flywheel.ModelBase
    % NOTE: This file is auto generated by the swagger code generator program.
    % Do not edit the file manually.
    properties (Constant)
        propertyMap = containers.Map({ 'sessionsChanged' }, ...
            { 'sessions_changed' });
    end
    properties(Dependent)
        sessionsChanged
    end
    methods
        function obj = SessionTemplateRecalcOutput(varargin)
            obj@flywheel.ModelBase(flywheel.model.SessionTemplateRecalcOutput.propertyMap);

            % Allow empty object creation
            if length(varargin)
                p = inputParser;
                addParameter(p, 'sessionsChanged', []);

                parse(p, varargin{:});

                if ~isempty(p.Results.sessionsChanged)
                    obj.props_('sessions_changed') = p.Results.sessionsChanged;
                end
            end
        end
        function result = get.sessionsChanged(obj)
            if ismethod(obj, 'get_sessionsChanged')
                result = obj.get_sessionsChanged();
            else
                if isKey(obj.props_, 'sessions_changed')
                    result = obj.props_('sessions_changed');
                else
                    result = [];
                end
            end
        end
        function obj = set.sessionsChanged(obj, value)
            obj.props_('sessions_changed') = value;
        end
        function result = toJson(obj)
            result = containers.Map;
            if isKey(obj.props_, 'sessions_changed')
                result('sessions_changed') = flywheel.ModelBase.serializeValue(obj.props_('sessions_changed'), 'vector[char]');
            end
        end
        function result = struct(obj)
            result = struct;

            if isKey(obj.props_, 'sessions_changed')
                result.sessionsChanged = obj.props_('sessions_changed');
            else
                result.sessionsChanged = [];
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
                if isKey(obj.props_, 'sessions_changed')
                    propList.sessionsChanged = obj.props_('sessions_changed');
                else
                    propList.sessionsChanged = [];
                end
                prpgrp = matlab.mixin.util.PropertyGroup(propList);
            end
        end
    end
    methods(Static)
        function obj = fromJson(json, context)
            obj =  flywheel.model.SessionTemplateRecalcOutput;
            if isfield(json, 'sessions_changed')
                obj.props_('sessions_changed') = flywheel.ModelBase.deserializeValue(json.sessions_changed, 'vector[char]');
            end
            if isprop(obj, 'context_')
                obj.setContext_(context);
            end
        end
        function obj = ensureIsInstance(obj)
            if ~isempty(obj)
                % Realistically, we only convert structs
                if ~isa(obj, 'flywheel.model.SessionTemplateRecalcOutput')
                    obj = flywheel.model.SessionTemplateRecalcOutput(obj);
                end
                if isKey(obj.props_, 'sessions_changed')
                end
            end
        end
    end
end
