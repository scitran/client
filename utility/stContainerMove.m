function stContainerMove(container,destination)
% Move a Flywheel container to a new destination
%
% Syntax
%   stContainerMove(container,destination)
%
% Brief Description
%  A container might be an acquisition and the destination would be a
%  session.  This is the only case I have tested.  I am hopeful that we can
%  handle other moves (e.g., a file from an acquisition to another
%  acquisition).
%
% Inputs
%    obj - the container to be moved
%    parent - the destination (parent) container
%
% Optional key/value pairs
%
% Returns
%   N/A
%
% Wandell, Jan 26, 2020
%
% See also
%

% Examples:
%{
% I made some test sessions and acquisition in Dental and tested this way.
st = scitran('stanfordlabs');
project = st.lookup('oraleye/Dental');
subjects = project.subjects();
thisSubject = stSelect(subjects,'label','000','nocell',true);
sessions = thisSubject.sessions();
thisSession = stSelect(sessions, ...
    'label','Test1', ...
    'nocell',true);
acquisitions = thisSession.acquisitions();

%  Move the acquisition from Test1 session to Test2
thisAcquisition = stSelect(acquisitions,'label','Unclear','nocell',true);
destinationSession = stSelect(sessions, ...
    'label','Test2', ...
    'nocell',true);
st.containerMove(thisAcquisition,destinationSession);
%}
%{
% Looks like files do not have enough info for a move.
thisAcquisition = stSelect(acquisitions,'label','test','nocell',true);
thisFile = thisAcquisition.files{1};
destinationSession = stSelect(sessions, ...
    'label','Test2', ...
    'nocell',true);
acquisitions = destinationSession.acquisitions();
destinationAcquisition = stSelect(acquisitions,'label','Unclear','nocell',true);
stContainerMove(thisFile,destinationAcquisition);
%}

%% Parse the inputs

p = inputParser;

% Both should be flywheel model objects
vFunc = @(x)(strncmp(class(x),'flywheel',8));
p.addRequired('container',vFunc);
p.addRequired('parent',vFunc);
p.parse(container,destination);


%% Based on the container type, check the destination and the move/update

cType = strsplit(class(container),'.');
switch lower(cType{3})
    case 'acquisition'
        dType = strsplit(class(destination),'.');
        if ~isequal(lower(dType{3}),'session')
            error('Acquisitions can only be moved to a session');
        end
        container.update('session',destination.id);
    case 'fileentry'
        warning('We can not move files.  Yet.');
        %{
        dType = strsplit(class(destination),'.');
        if ~isequal(lower(dType{3}),'acquisition')
            error('Files can only be moved to an acquisition.');
        end
        container.update('acquisition',destination.id);
        %}
    otherwise
        error('Not yet implemented for class %s\n',cType);
end


end