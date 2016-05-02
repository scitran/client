%% 
% These are derived from the data model of the scitran core
% https://github.com/scitran/core/wiki/Data-Model
%
% RF:  Can he help us look up the label from the id for principal objects.
%   Given a (param/id), session/id we should be able to quickly get the
%   label.
%
% The group has multiple projects
% We want to be able to get to this page
% https://flywheel.scitran.stanford.edu/#/dashboard/group/wandell
%
%   Label     - vwfa
%   Attachments
%   Notes
%   Sessions
%   Group - Wandell
%   ID
%   Tags
%   plink  - https://flywheel.scitran.stanford.edu/#/dashboard/group/wandell
%
% There is a base container class we have a subset of the container
% base
%   id
%   created
%   modified
%   notes
%   tags
%   files
%   analyses
%   label
%   metadata
%
% Project
%   Base +
%     group
%
% Session
%   Base +
%     parent group
%     parent project
%     subject
%
% Acquisition
%   Base +
%     parent session
%     list of collections that this acquisition is a member of
%     
% Files and Notes are part of the container
%   name
%   type
%   size
%   measurements - diffusion, functional, localizer, anatomy_t1, anatomy_t2, ASL,
%          perfusion, spectroscopy, EEG, MEG, PET, ...
%   tags
%   metadata
%
%   
      
% Sessions
% Download everything (including Pfiles? Dicoms?) from a session
%   or, exclude stuff except for niftis and bvecs, bvals, physiology
%
%

% The Project has a group associated with it
% There is a base container class we have a subset of the container
% base
stProject.label = ''
stProject.files = cell{1,1}
stProject.id    = ''
stProject.notes = cell{1,1}
stProject.group = ''  % Which group owns this project
stProject.plink = ''  % 'Shows all projects for a group'
stProject.sessions =  % Array of stSessions
%
stProject.misc.tags     = cell{1,1}
stProject.misc.analyses =
stProject.misc.metadata = cell{1,1}
stProject.misc.created  = ''
stProject.misc.modified = ''

% The return from a search should be 
stData.project
stData.project.sessions
stData.project.sessions.acquisitions
stData.project.sessions.acquisitions.files

files = stData.project.sessions.acquisitions.files

% A collection is a group of acquisitions
stCollections.acquisitions

stCollections.misc.

