function result = stParseSearch(stClient,srchResult)
% Simplify the fields in the struct returned by scitran search
%
%    result = stParseSearch(stClient,srchResult)
%
% The Flywheel search returns a JSON file that we read with jsonio (or
% JSONLAB).  The returned object is a Matlab struct.  Some of the fields in
% the struct are a bit awkward or ugly.  This routine re-writes the
% returned struct making the variables clearer.
%
% For JSONLAB, the returned object (files, sessions, acquisitions ...) is a
% cell array.  But for jsonio the returned object is an array of structs.
% In the jsonio case we convert the array of structs into a cell array of
% structs.
%
% For jsonio variables that are struct._FOO are returned as struct.x_FOO
% That is a key transformation here.
%
% LMP/BW Scitran Team, 2016

%% Define the search type and re-write the data into result

% Start empty.  Allocate later if there are data.
result = [];

% This is simply to clean up the look of the returned Matlab structure.
srchType = fieldnames(srchResult);
switch srchType{1}
    % TODO:  Sort several of these by their label before returning.
    case 'groups'
        nGroups = length(srchResult.groups);
        if nGroups == 0; return; end
        
        result = cell(1,nGroups);
        for ii=1:nGroups
            result{ii}.id     = srchResult.groups(ii).x_id;
            result{ii}.type   = srchResult.groups(ii).x_type;
            result{ii}.source = srchResult.groups(ii).x_source;
            result{ii}.score  = srchResult.groups(ii).x_score;
            result{ii}.index  = srchResult.groups(ii).x_index;
        end
    case 'projects'
        nProjects = length(srchResult.projects);
        if nProjects == 0; return; end

        result = cell(1,nProjects);
        for ii=1:nProjects
            result{ii}.id     = srchResult.projects(ii).x_id;
            result{ii}.type   = srchResult.projects(ii).x_type;
            result{ii}.source = srchResult.projects(ii).x_source;
            result{ii}.score  = srchResult.projects(ii).x_score;
            result{ii}.index  = srchResult.projects(ii).x_index;
        end
    case 'sessions'
        nSessions = length(srchResult.sessions);
        if nSessions == 0; return; end

        result = cell(1,nSessions);
        for ii=1:nSessions
            result{ii}.id     = srchResult.sessions(ii).x_id;
            result{ii}.type   = srchResult.sessions(ii).x_type;
            result{ii}.source = srchResult.sessions(ii).x_source;
            result{ii}.score  = srchResult.sessions(ii).x_score;
            result{ii}.index  = srchResult.sessions(ii).x_index;
        end
    case 'acquisitions'
        nAcquisitions = length(srchResult.acquisitions);
        if nAcquisitions == 0; return; end

        result = cell(1,nAcquisitions);
        for ii=1:nAcquisitions
            result{ii}.id     = srchResult.acquisitions(ii).x_id;
            result{ii}.type   = srchResult.acquisitions(ii).x_type;
            result{ii}.source = srchResult.acquisitions(ii).x_source;
            result{ii}.score  = srchResult.acquisitions(ii).x_score;
            result{ii}.index  = srchResult.acquisitions(ii).x_index;
        end
    case {'files','analyses/files'}
        nFiles = length(srchResult.files);
        if nFiles == 0; return; end
        
        result = cell(1,nFiles);
        for ii=1:nFiles
            result{ii}.id     = srchResult.files(ii).x_id;
            result{ii}.type   = srchResult.files(ii).x_type;
            result{ii}.source = srchResult.files(ii).x_source;
            result{ii}.score  = srchResult.files(ii).x_score;
            result{ii}.index  = srchResult.files(ii).x_index;
        end
    case 'collections'
        nCollections = length(srchResult.collections);
        if nCollections == 0; return; end

        result = cell(1,nCollections);
        for ii=1:nCollections
            result{ii}.id     = srchResult.collections(ii).x_id;
            result{ii}.type   = srchResult.collections(ii).x_type;
            result{ii}.source = srchResult.collections(ii).x_source;
            result{ii}.score  = srchResult.collections(ii).x_score;
            result{ii}.index  = srchResult.collections(ii).x_index;
        end
    case 'analyses'
        nAnalyses = length(srchResult.analyses);
        result = cell(1,nAnalyses);
        for ii=1:nAnalyses
            result{ii}.id     = srchResult.analyses(ii).x_id;
            result{ii}.type   = srchResult.analyses(ii).x_type;
            result{ii}.source = srchResult.analyses(ii).x_source;
            result{ii}.score  = srchResult.analyses(ii).x_score;
            result{ii}.index  = srchResult.analyses(ii).x_index;
        end
    otherwise
        error('Unknown search type %s\n',srchType{1})
end

%% If the user is searching for files, we build the plinks for each file

% The files might be part of an acquisition, or part of a session, or part
% of a project.  So many files, so little time.
% TODO: Handle session and project attachments
if strcmp(srchType,'files')
    n = length(result);
    
    % For each file in the return, find its container and create the
    % permalink.
    for ii=1:n
        cname = result{ii}.source.container_name;  % File's container
        
        % Files can be in a project, session, acquisition or analysis.
        switch cname
            case 'projects'
                % TO DEBUG ...
                projectid = result{ii}.source.project.x_id;
                fname = result{ii}.source.name;
                result{ii}.plink = sprintf('%s/api/%s/%s/files/%s',stClient.url, cname, projectid, fname);

            case 'sessions'
                % TO DEBUG ...
                sessionid = result{ii}.source.session.x_id;
                fname = result{ii}.source.name;
                result{ii}.plink = sprintf('%s/api/%s/%s/files/%s',stClient.url, cname, sessionid, fname);
                  
            case 'acquisitions'
                % acquisitionid = result{ii}.source.acquisition.x0x5F_id;
                acquisitionid = result{ii}.source.acquisition.x_id;
                fname = result{ii}.source.name;
                result{ii}.plink = sprintf('%s/api/%s/%s/files/%s',stClient.url, cname, acquisitionid, fname);
                
            case 'analyses'
                % The analysis files are stored within the session.  So we need
                % that id in addition to the analyseid.
                % sessionid = result{ii}.source.analyse.container.x0x5F_id;
                % analyseid = result{ii}.source.analyse.x0x5F_id;
                sessionid = result{ii}.source.analyse.container.x_id;
                analyseid = result{ii}.source.analyse.x_id;
                
                fname = result{ii}.source.name;
                result{ii}.plink = ...
                    sprintf('%s/api/sessions/%s/%s/%s/files/%s',...
                    stClient.url, sessionid, cname, analyseid, fname);            
            otherwise
                % error('Unknown file search mode');
        end
    end
end

end
