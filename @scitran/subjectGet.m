function val = subjectGet(st,project,param)
% Get the container metadata given its id
%
% Syntax:
%    val = scitran.subjectGet(project,param)
%
% Brief description:
%  Retrieve  Flywheel subject metadata from a project.
%
%  The most common application is converting the returns from a search,
%  which are of type SearchResponse, into Flywheel data. The search
%  includes the ID, so you can call this function. 
%
%  The conversion can be useful because the SearchResponse and Flywheel
%  data contain different information.
%
%  You can also force the search to return the Flywheel data format by
%  setting the 'fw' key/val option as true.
%
%       scitran.search('returnType', ..., 'fw',true)
%
%  In that case,  scitran.search calls stSearch2Container, which in turn
%  calls this function, after collecting up the SearchResponses.
%
% Inputs
%   id:  A project ID or a project structure.
%
% Optional key/value parameters
%   If none, the whole list of subjects is returned but without their
%   detailed metadata
%   'all' - If true subjects and their metadata are returned, otherwise
%           just the diminished list of subjects provided by Flywheel is
%           returned. By default true;
%   'param' - A specific parameter from the subject list
%   'info'  - All the info stored about the subject
%   'subjectid' - Return for just a single subject
%
% Outputs
%   val:  The subject array or the parameter as a cell array
%
% Wandell, Vistasoft Team, 2019
%
% See also
%   scitran.analysisGet, scitran.containerGet
%

% Examples:
%{
 st = scitran('stanfordlabs');
 project = st.lookup('oraleye/Dental');
 allsubjects = st.subjectGet(project);   % With their metadata
 allsubjects = st.subjectGet(project.id,'all',false);

 allLabels   = st.subjectGet(project,'label');
 allLabels   = st.subjectGet(project,'sex');

%}

%% Check the inputs

%% USE .reload to get the information as per LMP's email message

if notDefined('param'), param=''; end

p = inputParser;
p.addRequired('st',@(x)(isa(x,'scitran')));
p.addRequired('project',@(x)(ischar(x) || ischar(x.id)));
p.addRequired('param',@ischar);

p.parse(st,project,param);

%%
if ischar(project)
    % The user provided the ID
    project = st.fw.get(project);
end

subjects = project.subjects();
nSubjects = numel(subjects);
val = cell(nSubjects,1);

switch ieParamFormat(param)
    case 'all'
        % User wanted the metadata
        for ii=1:nSubjects
            val{ii} = subjects{ii}.reload;
        end
        return;
    case ''
        % User wanted the brief list
        val = subjects;
        return;
    otherwise
        % User sent a char that should be a subject parameter
        for ii=1:nSubjects
            subjects{ii}.reload;
            val{ii} = char(subjects{ii}.(param));
        end
        return;
end

end
