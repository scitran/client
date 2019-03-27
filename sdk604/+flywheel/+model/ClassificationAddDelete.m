% ClassificationAddDelete
%
% ClassificationAddDelete Properties:
%    add    
%    delete 
%
% ClassificationAddDelete Methods:
%    toJson - Convert the object to a Map that can be encoded to json
%    struct - Convert the object to a struct
    classdef ClassificationAddDelete < flywheel.ModelBase
    % NOTE: This file is auto generated by the swagger code generator program.
    % Do not edit the file manually.
    properties (Constant)
        propertyMap = containers.Map({ 'add', 'delete' }, ...
            { 'add', 'delete' });
    end
    properties(Dependent)
        add
        delete
    end
    methods
        function obj = ClassificationAddDelete(varargin)
            obj@flywheel.ModelBase(flywheel.model.ClassificationAddDelete.propertyMap);

            % Allow empty object creation
            if length(varargin)
                p = inputParser;
                addParameter(p, 'add', []);
                addParameter(p, 'delete', []);

                parse(p, varargin{:});

                if ~isempty(p.Results.add)
                    obj.props_('add') = p.Results.add;
                end
                if ~isempty(p.Results.delete)
                    obj.props_('delete') = p.Results.delete;
                end
            end
        end
        function result = get.add(obj)
            if ismethod(obj, 'get_add')
                result = obj.get_add();
            else
                if isKey(obj.props_, 'add')
                    result = obj.props_('add');
                else
                    result = [];
                end
            end
        end
        function obj = set.add(obj, value)
            obj.props_('add') = value;
        end
        function result = get.delete(obj)
            if ismethod(obj, 'get_delete')
                result = obj.get_delete();
            else
                if isKey(obj.props_, 'delete')
                    result = obj.props_('delete');
                else
                    result = [];
                end
            end
        end
        function obj = set.delete(obj, value)
            obj.props_('delete') = value;
        end
        function result = toJson(obj)
            result = containers.Map;
            if isKey(obj.props_, 'add')
                result('add') = obj.props_('add').toJson();
            end
            if isKey(obj.props_, 'delete')
                result('delete') = obj.props_('delete').toJson();
            end
        end
        function result = struct(obj)
            result = struct;

            if isKey(obj.props_, 'add')
                result.add = struct(obj.props_('add'));
            else
                result.add = [];
            end
            if isKey(obj.props_, 'delete')
                result.delete = struct(obj.props_('delete'));
            else
                result.delete = [];
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
                if isKey(obj.props_, 'add')
                    propList.add = obj.props_('add');
                else
                    propList.add = [];
                end
                if isKey(obj.props_, 'delete')
                    propList.delete = obj.props_('delete');
                else
                    propList.delete = [];
                end
                prpgrp = matlab.mixin.util.PropertyGroup(propList);
            end
        end
    end
    methods(Static)
        function obj = fromJson(json, context)
            obj =  flywheel.model.ClassificationAddDelete;
            if isfield(json, 'add')
                obj.props_('add') = flywheel.model.CommonClassification.fromJson(json.add, context);
            end
            if isfield(json, 'delete')
                obj.props_('delete') = flywheel.model.CommonClassification.fromJson(json.delete, context);
            end
            if isprop(obj, 'context_')
                obj.setContext_(context);
            end
        end
        function obj = ensureIsInstance(obj)
            if ~isempty(obj)
                % Realistically, we only convert structs
                if ~isa(obj, 'flywheel.model.ClassificationAddDelete')
                    obj = flywheel.model.ClassificationAddDelete(obj);
                end
                if isKey(obj.props_, 'add')
                    obj.props_('add') =  flywheel.model.CommonClassification.ensureIsInstance(obj.props_('add'));
                end
                if isKey(obj.props_, 'delete')
                    obj.props_('delete') =  flywheel.model.CommonClassification.ensureIsInstance(obj.props_('delete'));
                end
            end
        end
    end
end