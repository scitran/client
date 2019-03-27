% ConfigSiteConfigOutput
%
% ConfigSiteConfigOutput Properties:
%    centralUrl 
%    sslCert    
%    apiUrl     
%    registered 
%    id         
%    name       
%
% ConfigSiteConfigOutput Methods:
%    toJson - Convert the object to a Map that can be encoded to json
%    struct - Convert the object to a struct
    classdef ConfigSiteConfigOutput < flywheel.ModelBase
    % NOTE: This file is auto generated by the swagger code generator program.
    % Do not edit the file manually.
    properties (Constant)
        propertyMap = containers.Map({ 'centralUrl', 'sslCert', 'apiUrl', 'registered', 'id', 'name' }, ...
            { 'central_url', 'ssl_cert', 'api_url', 'registered', 'id', 'name' });
    end
    properties(Dependent)
        centralUrl
        sslCert
        apiUrl
        registered
        id
        name
    end
    methods
        function obj = ConfigSiteConfigOutput(varargin)
            obj@flywheel.ModelBase(flywheel.model.ConfigSiteConfigOutput.propertyMap);

            % Allow empty object creation
            if length(varargin)
                p = inputParser;
                addParameter(p, 'centralUrl', []);
                addParameter(p, 'sslCert', []);
                addParameter(p, 'apiUrl', []);
                addParameter(p, 'registered', []);
                addParameter(p, 'id', []);
                addParameter(p, 'name', []);

                parse(p, varargin{:});

                if ~isempty(p.Results.centralUrl)
                    obj.props_('central_url') = p.Results.centralUrl;
                end
                if ~isempty(p.Results.sslCert)
                    obj.props_('ssl_cert') = p.Results.sslCert;
                end
                if ~isempty(p.Results.apiUrl)
                    obj.props_('api_url') = p.Results.apiUrl;
                end
                if ~isempty(p.Results.registered)
                    obj.props_('registered') = p.Results.registered;
                end
                if ~isempty(p.Results.id)
                    obj.props_('id') = p.Results.id;
                end
                if ~isempty(p.Results.name)
                    obj.props_('name') = p.Results.name;
                end
            end
        end
        function result = get.centralUrl(obj)
            if ismethod(obj, 'get_centralUrl')
                result = obj.get_centralUrl();
            else
                if isKey(obj.props_, 'central_url')
                    result = obj.props_('central_url');
                else
                    result = [];
                end
            end
        end
        function obj = set.centralUrl(obj, value)
            obj.props_('central_url') = value;
        end
        function result = get.sslCert(obj)
            if ismethod(obj, 'get_sslCert')
                result = obj.get_sslCert();
            else
                if isKey(obj.props_, 'ssl_cert')
                    result = obj.props_('ssl_cert');
                else
                    result = [];
                end
            end
        end
        function obj = set.sslCert(obj, value)
            obj.props_('ssl_cert') = value;
        end
        function result = get.apiUrl(obj)
            if ismethod(obj, 'get_apiUrl')
                result = obj.get_apiUrl();
            else
                if isKey(obj.props_, 'api_url')
                    result = obj.props_('api_url');
                else
                    result = [];
                end
            end
        end
        function obj = set.apiUrl(obj, value)
            obj.props_('api_url') = value;
        end
        function result = get.registered(obj)
            if ismethod(obj, 'get_registered')
                result = obj.get_registered();
            else
                if isKey(obj.props_, 'registered')
                    result = obj.props_('registered');
                else
                    result = [];
                end
            end
        end
        function obj = set.registered(obj, value)
            obj.props_('registered') = value;
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
        function result = get.name(obj)
            if ismethod(obj, 'get_name')
                result = obj.get_name();
            else
                if isKey(obj.props_, 'name')
                    result = obj.props_('name');
                else
                    result = [];
                end
            end
        end
        function obj = set.name(obj, value)
            obj.props_('name') = value;
        end
        function result = toJson(obj)
            result = containers.Map;
            if isKey(obj.props_, 'central_url')
                result('central_url') = flywheel.ModelBase.serializeValue(obj.props_('central_url'), 'char');
            end
            if isKey(obj.props_, 'ssl_cert')
                result('ssl_cert') = flywheel.ModelBase.serializeValue(obj.props_('ssl_cert'), 'char');
            end
            if isKey(obj.props_, 'api_url')
                result('api_url') = flywheel.ModelBase.serializeValue(obj.props_('api_url'), 'char');
            end
            if isKey(obj.props_, 'registered')
                result('registered') = flywheel.ModelBase.serializeValue(obj.props_('registered'), 'logical');
            end
            if isKey(obj.props_, 'id')
                result('id') = flywheel.ModelBase.serializeValue(obj.props_('id'), 'char');
            end
            if isKey(obj.props_, 'name')
                result('name') = flywheel.ModelBase.serializeValue(obj.props_('name'), 'char');
            end
        end
        function result = struct(obj)
            result = struct;

            if isKey(obj.props_, 'central_url')
                result.centralUrl = obj.props_('central_url');
            else
                result.centralUrl = [];
            end
            if isKey(obj.props_, 'ssl_cert')
                result.sslCert = obj.props_('ssl_cert');
            else
                result.sslCert = [];
            end
            if isKey(obj.props_, 'api_url')
                result.apiUrl = obj.props_('api_url');
            else
                result.apiUrl = [];
            end
            if isKey(obj.props_, 'registered')
                result.registered = obj.props_('registered');
            else
                result.registered = [];
            end
            if isKey(obj.props_, 'id')
                result.id = obj.props_('id');
            else
                result.id = [];
            end
            if isKey(obj.props_, 'name')
                result.name = obj.props_('name');
            else
                result.name = [];
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
                if isKey(obj.props_, 'central_url')
                    propList.centralUrl = obj.props_('central_url');
                else
                    propList.centralUrl = [];
                end
                if isKey(obj.props_, 'ssl_cert')
                    propList.sslCert = obj.props_('ssl_cert');
                else
                    propList.sslCert = [];
                end
                if isKey(obj.props_, 'api_url')
                    propList.apiUrl = obj.props_('api_url');
                else
                    propList.apiUrl = [];
                end
                if isKey(obj.props_, 'registered')
                    propList.registered = obj.props_('registered');
                else
                    propList.registered = [];
                end
                if isKey(obj.props_, 'id')
                    propList.id = obj.props_('id');
                else
                    propList.id = [];
                end
                if isKey(obj.props_, 'name')
                    propList.name = obj.props_('name');
                else
                    propList.name = [];
                end
                prpgrp = matlab.mixin.util.PropertyGroup(propList);
            end
        end
    end
    methods(Static)
        function obj = fromJson(json, context)
            obj =  flywheel.model.ConfigSiteConfigOutput;
            if isfield(json, 'central_url')
                obj.props_('central_url') = flywheel.ModelBase.deserializeValue(json.central_url, 'char');
            end
            if isfield(json, 'ssl_cert')
                obj.props_('ssl_cert') = flywheel.ModelBase.deserializeValue(json.ssl_cert, 'char');
            end
            if isfield(json, 'api_url')
                obj.props_('api_url') = flywheel.ModelBase.deserializeValue(json.api_url, 'char');
            end
            if isfield(json, 'registered')
                obj.props_('registered') = flywheel.ModelBase.deserializeValue(json.registered, 'logical');
            end
            if isfield(json, 'id')
                obj.props_('id') = flywheel.ModelBase.deserializeValue(json.id, 'char');
            end
            if isfield(json, 'name')
                obj.props_('name') = flywheel.ModelBase.deserializeValue(json.name, 'char');
            end
            if isprop(obj, 'context_')
                obj.setContext_(context);
            end
        end
        function obj = ensureIsInstance(obj)
            if ~isempty(obj)
                % Realistically, we only convert structs
                if ~isa(obj, 'flywheel.model.ConfigSiteConfigOutput')
                    obj = flywheel.model.ConfigSiteConfigOutput(obj);
                end
                if isKey(obj.props_, 'central_url')
                end
                if isKey(obj.props_, 'ssl_cert')
                end
                if isKey(obj.props_, 'api_url')
                end
                if isKey(obj.props_, 'registered')
                end
                if isKey(obj.props_, 'id')
                end
                if isKey(obj.props_, 'name')
                end
            end
        end
    end
end