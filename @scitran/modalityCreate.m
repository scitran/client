function modalityCreate(st,name,varargin)
% Create a new Flywheel modality defining the properties of a data type
%
% Inputs
%   name:      Modality name (a string)
%
% Optional Key/Value pairs
%  classification:  Struct defining options for modality properties
%
% Returns
%   None
%
% BW, Vistasoft Team, 2018
%
% See also
%   scitran.modalityReplace

%{

name = 'Dental'
classification = ...
    struct('data', {{'radiance', 'rgb'}}, ...
    'location',{{'whitesurface','teeth', ...
    'tonguelateral','tongueventral','tonguedorsal',...
    'lowerinnerlip','hardpalate','cheek','floorofmouth'}});
st.modalityCreate(name,'classification',classification);

%}

%%
p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('modality',@(x)(isa(x,'flywheel.model.Modality')));
p.addParameter('classification',[],@isstruct);

p.parse(st,name,varargin{:});

classification = p.Results.classification;

%%  Create the modality object and add it to Flywheel

modality = flywheel.model.Modality('id', name, 'classification', classification);

% The name (id) and a classification specification.
st.fw.addModality(modality);

end