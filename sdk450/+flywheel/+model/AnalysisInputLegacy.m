% AnalysisInputLegacy
%
% AnalysisInputLegacy Properties:
%    inputs       - The set of inputs that this analysis is based on
%    outputs     
%    description 
%    label        - Application-specific label
%
% AnalysisInputLegacy Methods:
%    toJson - Convert the object to a Map that can be encoded to json
%    struct - Convert the object to a struct
    classdef AnalysisInputLegacy < flywheel.ModelBase
    % NOTE: This file is auto generated by the swagger code generator program.
    % Do not edit the file manually.
    properties (Constant)
        propertyMap = containers.Map({ 'inputs', 'outputs', 'description', 'label' }, ...
            { 'inputs', 'outputs', 'description', 'label' });
    end
    properties(Dependent)
        inputs
        outputs
        description
        label
    end
    methods
        function obj = AnalysisInputLegacy(varargin)
            obj@flywheel.ModelBase(flywheel.model.AnalysisInputLegacy.propertyMap);

            % Allow empty object creation
            if length(varargin)
                p = inputParser;
                addParameter(p, 'inputs', []);
                addParameter(p, 'outputs', []);
                addParameter(p, 'description', []);
                addParameter(p, 'label', []);

                parse(p, varargin{:});

                if ~isempty(p.Results.inputs)
                    obj.props_('inputs') = p.Results.inputs;
                end
                if ~isempty(p.Results.outputs)
                    obj.props_('outputs') = p.Results.outputs;
                end
                if ~isempty(p.Results.description)
                    obj.props_('description') = p.Results.description;
                end
                if ~isempty(p.Results.label)
                    obj.props_('label') = p.Results.label;
                end
            end
        end
        function result = get.inputs(obj)
            if ismethod(obj, 'get_inputs')
                result = obj.get_inputs();
            else
                if isKey(obj.props_, 'inputs')
                    result = obj.props_('inputs');
                else
                    result = [];
                end
            end
        end
        function obj = set.inputs(obj, value)
            obj.props_('inputs') = value;
        end
        function result = get.outputs(obj)
            if ismethod(obj, 'get_outputs')
                result = obj.get_outputs();
            else
                if isKey(obj.props_, 'outputs')
                    result = obj.props_('outputs');
                else
                    result = [];
                end
            end
        end
        function obj = set.outputs(obj, value)
            obj.props_('outputs') = value;
        end
        function result = get.description(obj)
            if ismethod(obj, 'get_description')
                result = obj.get_description();
            else
                if isKey(obj.props_, 'description')
                    result = obj.props_('description');
                else
                    result = [];
                end
            end
        end
        function obj = set.description(obj, value)
            obj.props_('description') = value;
        end
        function result = get.label(obj)
            if ismethod(obj, 'get_label')
                result = obj.get_label();
            else
                if isKey(obj.props_, 'label')
                    result = obj.props_('label');
                else
                    result = [];
                end
            end
        end
        function obj = set.label(obj, value)
            obj.props_('label') = value;
        end
        function result = toJson(obj)
            result = containers.Map;
            if isKey(obj.props_, 'inputs')
                result('inputs') = flywheel.ModelBase.cellmap(@toJson, obj.props_('inputs'));
            end
            if isKey(obj.props_, 'outputs')
                result('outputs') = flywheel.ModelBase.cellmap(@toJson, obj.props_('outputs'));
            end
            if isKey(obj.props_, 'description')
                result('description') = flywheel.ModelBase.serializeValue(obj.props_('description'), 'char');
            end
            if isKey(obj.props_, 'label')
                result('label') = flywheel.ModelBase.serializeValue(obj.props_('label'), 'char');
            end
        end
        function result = struct(obj)
            result = struct;

            if isKey(obj.props_, 'inputs')
                result.inputs = flywheel.ModelBase.cellmap(@struct, obj.props_('inputs'));
            else
                result.inputs = [];
            end
            if isKey(obj.props_, 'outputs')
                result.outputs = flywheel.ModelBase.cellmap(@struct, obj.props_('outputs'));
            else
                result.outputs = [];
            end
            if isKey(obj.props_, 'description')
                result.description = obj.props_('description');
            else
                result.description = [];
            end
            if isKey(obj.props_, 'label')
                result.label = obj.props_('label');
            else
                result.label = [];
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
                if isKey(obj.props_, 'inputs')
                    propList.inputs = obj.props_('inputs');
                else
                    propList.inputs = [];
                end
                if isKey(obj.props_, 'outputs')
                    propList.outputs = obj.props_('outputs');
                else
                    propList.outputs = [];
                end
                if isKey(obj.props_, 'description')
                    propList.description = obj.props_('description');
                else
                    propList.description = [];
                end
                if isKey(obj.props_, 'label')
                    propList.label = obj.props_('label');
                else
                    propList.label = [];
                end
                prpgrp = matlab.mixin.util.PropertyGroup(propList);
            end
        end
    end
    methods(Static)
        function obj = fromJson(json, context)
            obj =  flywheel.model.AnalysisInputLegacy;
            if isfield(json, 'inputs')
                obj.props_('inputs') = flywheel.ModelBase.cellmap(@(x) flywheel.model.FileEntry.fromJson(x, context), json.inputs);
            end
            if isfield(json, 'outputs')
                obj.props_('outputs') = flywheel.ModelBase.cellmap(@(x) flywheel.model.FileEntry.fromJson(x, context), json.outputs);
            end
            if isfield(json, 'description')
                obj.props_('description') = flywheel.ModelBase.deserializeValue(json.description, 'char');
            end
            if isfield(json, 'label')
                obj.props_('label') = flywheel.ModelBase.deserializeValue(json.label, 'char');
            end
            if isprop(obj, 'context_')
                obj.setContext_(context);
            end
        end
        function obj = ensureIsInstance(obj)
            if ~isempty(obj)
                % Realistically, we only convert structs
                if ~isa(obj, 'flywheel.model.AnalysisInputLegacy')
                    obj = flywheel.model.AnalysisInputLegacy(obj);
                end
                if isKey(obj.props_, 'inputs')
                    obj.props_('inputs') = flywheel.ModelBase.cellmap(@flywheel.model.FileEntry.ensureIsInstance, obj.props_('inputs'));
                end
                if isKey(obj.props_, 'outputs')
                    obj.props_('outputs') = flywheel.ModelBase.cellmap(@flywheel.model.FileEntry.ensureIsInstance, obj.props_('outputs'));
                end
                if isKey(obj.props_, 'description')
                end
                if isKey(obj.props_, 'label')
                end
            end
        end
    end
end