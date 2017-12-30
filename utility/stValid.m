function v = stValid(param)
% Return cell array of valid parameters for different cases
%
% Syntax
%    stValid(param)
%
% Description
%
% Note: This functionality should be included in the SDK
%
% BW, Vistasoft Team, 2017

% Example
%{
stValid('file type')
stValid('data type')
%}
%%
p = inputParser;
p.addRequired('param',@ischar);
param = stParamFormat(param);

%%
switch param
    case 'filetype'
        % This should be returned by the SDK
        v = {'nifti','dicom','null','tabular data',...
            'bval','bvec','text','MATLAB data','pdf',...
            'montage','qa','markup','archive','pfile','source code'};
    case {'datatype','classification'}
        v = {'null','diffusion','diffusion_map','anatomy_t1w',...
            'functional_map','functional','unknown','localizer',...
            'anatomy_t2w','anatomy_ir','screenshot',...
            'calibration','phase_map','high_order_shim','field_map'}; 
    otherwise
        error('Unknown parameter %s\n',param);
end


end

