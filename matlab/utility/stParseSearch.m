function result = stParseSearch(stObj,srchResult)
% Parse the scitran object and a search structure
%
%
%
% LMP/BW Scitran Team, 2016

%% Define the search type and re-write the data into result

% This is simply to clean up the look of the returned Matlab structure.
srchType = fieldnames(srchResult);
switch srchType{1}
    % TODO:  Sort several of these by their label before returning.
    case 'projects'
        nProjects = length(srchResult.projects);
        result = cell(1,nProjects);
        for ii=1:nProjects
            result{ii}.id     = srchResult.projects{ii}.x0x5F_id;
            result{ii}.type   = srchResult.projects{ii}.x0x5F_type;
            result{ii}.source = srchResult.projects{ii}.x0x5F_source;
            result{ii}.score  = srchResult.projects{ii}.x0x5F_score;
            result{ii}.index  = srchResult.projects{ii}.x0x5F_index;
        end
    case 'sessions'
        nSessions = length(srchResult.sessions);
        result = cell(1,nSessions);
        for ii=1:nSessions
            result{ii}.id     = srchResult.sessions{ii}.x0x5F_id;
            result{ii}.type   = srchResult.sessions{ii}.x0x5F_type;
            result{ii}.source = srchResult.sessions{ii}.x0x5F_source;
            result{ii}.score  = srchResult.sessions{ii}.x0x5F_score;
            result{ii}.index  = srchResult.sessions{ii}.x0x5F_index;
        end
    case 'acquisitions'
        nAcquisitions = length(srchResult.acquisitions);
        result = cell(1,nAcquisitions);
        for ii=1:nAcquisitions
            result{ii}.id     = srchResult.acquisitions{ii}.x0x5F_id;
            result{ii}.type   = srchResult.acquisitions{ii}.x0x5F_type;
            result{ii}.source = srchResult.acquisitions{ii}.x0x5F_source;
            result{ii}.score  = srchResult.acquisitions{ii}.x0x5F_score;
            result{ii}.index  = srchResult.acquisitions{ii}.x0x5F_index;
        end
    case {'files','analyses/files'}
        nFiles = length(srchResult.files);
        result = cell(1,nFiles);
        for ii=1:nFiles
            result{ii}.id     = srchResult.files{ii}.x0x5F_id;
            result{ii}.type   = srchResult.files{ii}.x0x5F_type;
            result{ii}.source = srchResult.files{ii}.x0x5F_source;
            result{ii}.score  = srchResult.files{ii}.x0x5F_score;
            result{ii}.index  = srchResult.files{ii}.x0x5F_index;
        end
    case 'collections'
        nCollections = length(srchResult.collections);
        result = cell(1,nCollections);
        for ii=1:nCollections
            result{ii}.id     = srchResult.collections{ii}.x0x5F_id;
            result{ii}.type   = srchResult.collections{ii}.x0x5F_type;
            result{ii}.source = srchResult.collections{ii}.x0x5F_source;
            result{ii}.score  = srchResult.collections{ii}.x0x5F_score;
            result{ii}.index  = srchResult.collections{ii}.x0x5F_index;
        end
    case 'analyses'
        nAnalyses = length(srchResult.analyses);
        result = cell(1,nAnalyses);
        for ii=1:nAnalyses
            result{ii}.id     = srchResult.analyses{ii}.x0x5F_id;
            result{ii}.type   = srchResult.analyses{ii}.x0x5F_type;
            result{ii}.source = srchResult.analyses{ii}.x0x5F_source;
            result{ii}.score  = srchResult.analyses{ii}.x0x5F_score;
            result{ii}.index  = srchResult.analyses{ii}.x0x5F_index;
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
    
    % Sometimes just files, sometimes analyses/files
    switch result{1}.source.container_name
        case 'acquisitions'
            for ii=1:n
                cname = result{ii}.source.container_name;
                if strcmpi(cname, 'acquisitions') % Only add files from acquisitions to result
                    acquisitionid = result{ii}.source.acquisition.x0x5F_id;
                    fname = result{ii}.source.name;
                    result{ii}.plink = sprintf('%s/api/%s/%s/files/%s',stObj.url, cname, acquisitionid, fname);
                end
            end
            
        case 'analyses'
            % The analysis files are stored within the session.  So we need
            % that id in addition to the analyseid.
            for ii=1:n
                cname = result{ii}.source.container_name;
                if strcmpi(cname, 'analyses') % Only add files from acquisitions to result
                    sessionid = result{ii}.source.analyse.container.x0x5F_id;
                    analyseid = result{ii}.source.analyse.x0x5F_id;
                    fname = result{ii}.source.name;
                    result{ii}.plink = ...
                        sprintf('%s/api/sessions/%s/%s/%s/files/%s',...
                        stObj.url, sessionid, cname, analyseid, fname);
                end
            end
            
        otherwise
            % error('Unknown file search mode');
    end
end


end
