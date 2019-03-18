function v = stValid(param,str)
% Return cell array of valid parameters for different cases
%
% Syntax
%    v = stValid(param,value)
%
% Description
%   Returns the valid strings for different scitran functions.  If a string
%   is provided as a second argument, the return is a logical confirming
%   whether or not the string is valid.
%
% Inputs
%   param: 'filetype','datatype','searchreturn','measurement'
%
% Optional
%   str:   A string, a logical will be returned if str is part of the valid
%          cell array
%
% Key/value pairs
%   N/A
%
% Outputs
%   v:  Cell array of valid values, or if logical (true/false) if str
%       parameter is included
%
% Note: This functionality should be included in the SDK
%
% BW, Vistasoft Team, 2017
%
% See also
%   scitran.search, s_stSearches
%  

% Examples:
%{
  stValid('file type')
  stValid('data type')
  stValid('search return','file')
  stValid('measurement','B0')
%}

%% Parse inputs
p = inputParser;
p.addRequired('param',@ischar);
param = stParamFormat(param);

if notDefined('str'), str = ''; end

%%
switch param
    case 'filetype'
        % Known file types; this value should be returned by the SDK
        v = {'nifti','dicom','null','tabular data',...
            'bval','bvec','text','MATLAB data','pdf',...
            'montage','qa','markup','archive','pfile','source code', ...
            'CG Resource'};
    case {'datatype','classification'}
        % Data type classifications
        v = {'null','diffusion','diffusion_map','anatomy_t1w',...
            'functional_map','functional','unknown','localizer',...
            'anatomy_t2w','anatomy_ir','screenshot',...
            'calibration','phase_map','high_order_shim','field_map'}; 
    case {'searchreturn'}
        % What you can ask for in a search
        v = {'group','project','session','acquisition','file',...
            'analysis','analysessession','analysesproject', ...
            'collection','collectionsession','collectionacquisition',...
            'modality','acquisitionfile','subject'};
    case {'measurement'}
        % Type of measurement
        % MR = st.fw.getModality('MR');
        % valid = MR.classification.Measurement;
        v = {'B0','B1','T1','T2', 'T2*','PD','MT','ASL',...
            'Perfusion', 'Diffusion','Spectroscopy','Susceptibility',...
            'Velocity','Fingerprinting'};
    otherwise
        error('Unknown parameter %s\n',param);
end

if ~isempty(str)
   v = ismember(str,v);
end

end

