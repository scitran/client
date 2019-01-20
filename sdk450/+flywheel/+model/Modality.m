% Modality
%
% Modality Properties:
%    id              - Unique database ID
%    classification 
%
% Modality Methods:
%    toJson - Convert the object to a Map that can be encoded to json
%    struct - Convert the object to a struct
    classdef Modality < flywheel.ModelBase
    % NOTE: This file is auto generated by the swagger code generator program.
    % Do not edit the file manually.
    properties (Constant)
        propertyMap = containers.Map({ 'id', 'classification' }, ...
            { '_id', 'classification' });
    end
    properties(Dependent)
        id
        classification
    end
    methods
        function obj = Modality(varargin)
            obj@flywheel.ModelBase(flywheel.model.Modality.propertyMap);

            % Allow empty object creation
            if length(varargin)
                p = inputParser;
                addParameter(p, 'id', []);
                addParameter(p, 'classification', []);

                parse(p, varargin{:});

                if ~isempty(p.Results.id)
                    obj.props_('_id') = p.Results.id;
                end
                if ~isempty(p.Results.classification)
                    obj.props_('classification') = p.Results.classification;
                end
            end
        end
        function result = get.id(obj)
            if ismethod(obj, 'get_id')
                result = obj.get_id();
            else
                if isKey(obj.props_, '_id')
                    result = obj.props_('_id');
                else
                    result = [];
                end
            end
        end
        function obj = set.id(obj, value)
            obj.props_('_id') = value;
        end
        function result = get.classification(obj)
            if ismethod(obj, 'get_classification')
                result = obj.get_classification();
            else
                if isKey(obj.props_, 'classification')
                    result = obj.props_('classification');
                else
                    result = [];
                end
            end
        end
        function obj = set.classification(obj, value)
            obj.props_('classification') = value;
        end
        function result = toJson(obj)
            result = containers.Map;
            if isKey(obj.props_, '_id')
                result('_id') = flywheel.ModelBase.serializeValue(obj.props_('_id'), 'char');
            end
            if isKey(obj.props_, 'classification')
                result('classification') = obj.props_('classification').toJson();
            end
        end
        function result = struct(obj)
            result = struct;

            if isKey(obj.props_, '_id')
                result.id = obj.props_('_id');
            else
                result.id = [];
            end
            if isKey(obj.props_, 'classification')
                result.classification = struct(obj.props_('classification'));
            else
                result.classification = [];
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
                if isKey(obj.props_, '_id')
                    propList.id = obj.props_('_id');
                else
                    propList.id = [];
                end
                if isKey(obj.props_, 'classification')
                    propList.classification = obj.props_('classification');
                else
                    propList.classification = [];
                end
                prpgrp = matlab.mixin.util.PropertyGroup(propList);
            end
        end
    end
    methods(Static)
        function obj = fromJson(json, context)
            obj =  flywheel.model.Modality;
            if isfield(json, 'x0x5Fid')
                obj.props_('_id') = flywheel.ModelBase.deserializeValue(json.x0x5Fid, 'char');
            end
            if isfield(json, 'classification')
                obj.props_('classification') = flywheel.model.CommonClassification.fromJson(json.classification, context);
            end
            if isprop(obj, 'context_')
                obj.setContext_(context);
            end
        end
        function obj = ensureIsInstance(obj)
            if ~isempty(obj)
                % Realistically, we only convert structs
                if ~isa(obj, 'flywheel.model.Modality')
                    obj = flywheel.model.Modality(obj);
                end
                if isKey(obj.props_, '_id')
                end
                if isKey(obj.props_, 'classification')
                    obj.props_('classification') =  flywheel.model.CommonClassification.ensureIsInstance(obj.props_('classification'));
                end
            end
        end
    end
end