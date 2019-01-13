function v = stValid(param,str)
% Return cell array of valid parameters for different cases
%
% Syntax
%    status = stValid(param,value)
%
% Description
%   Returns the valid strings for different scitran functions.  If a string
%   is provided as a second argument, the return is a true/false logical
%   confirming whether or not the string is valid for that parameter.
%
% Inputs
% Key/value pairs
% Outputs
%
% Note: This functionality should be included in the SDK
%
% BW, Vistasoft Team, 2017

% Example
%{
stValid('file type')
stValid('data type')
stValid('search return','file')
%}

%% Parse inputs
p = inputParser;
p.addRequired('param',@ischar);
param = stParamFormat(param);

if notDefined('str'), str = ''; end

%%
switch param
    case 'filetype'
        % This should be returned by the SDK
        v = {'nifti','dicom','null','tabular data',...
            'bval','bvec','text','MATLAB data','pdf',...
            'montage','qa','markup','archive','pfile','source code', ...
            'CG Resource'};
    case {'datatype','classification'}
        v = {'null','diffusion','diffusion_map','anatomy_t1w',...
            'functional_map','functional','unknown','localizer',...
            'anatomy_t2w','anatomy_ir','screenshot',...
            'calibration','phase_map','high_order_shim','field_map'}; 
    case {'searchreturn'}
        v = {'group','project','session','acquisition','file',...
            'analysis','analysessession','analysesproject', ...
            'collection','collectionsession','collectionacquisition',...
            'modality','acquisitionfile','subject'};
    otherwise
        error('Unknown parameter %s\n',param);
end

if ~isempty(str)
   v = ismember(str,v);
end

end

