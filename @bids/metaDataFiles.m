function [projectMeta, subjectMeta, sessionMeta] = metaDataFiles(obj)
% METADATAFILE
%
%  Make a cell array of the meta data files at each of the different levels
%    Project (root directory)     cell is 1
%    Per Subject                  cell is nParticipants
%    Per Subject per Session      cell is nParticipants/Sessions
%
% DH, Scitran Team, 2017

projectMeta = cell(1,1);
subjectMeta = cell(obj.nParticipants,1);
sessionMeta = cell(obj.nParticipants,1);

end
