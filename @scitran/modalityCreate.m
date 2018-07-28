function modalityCreate(st,name,varargin)
% Create a new Flywheel modality defining the properties of a data type
%
% Inputs
%   name:      Modality name, assigned to be the modality 'id'
%
% Optional Key/Value pairs
%  classification:  Struct defining options for classifications within the
%                   modality
%
% Returns
%   None
%
% BW, Vistasoft Team, 2018
%
% See also
%   scitran.modalityReplace

% Examples:
%{
name = 'Dental';
classification = ...
    struct(...
    'data', {{'radiance', 'rgb'}}, ...
    'location',{{'whitesurface','teeth', ...
      'tonguelateral','tongueventral','tonguedorsal',...
      'lowerinnerlip','hardpalate','cheek','floorofmouth'}});
st.modalityCreate(name,'classification',classification);
%}

%%
p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('name',@ischar);
p.addParameter('classification',[],@isstruct);

p.parse(st,name,varargin{:});

classification = p.Results.classification;

%%  Create the modality object and add it to Flywheel

modality = flywheel.model.Modality('id', name, 'classification', classification);

% The name (id) and the classification specification.
st.fw.addModality(modality);

end