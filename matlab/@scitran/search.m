function [result, srchFile] = search(obj,srch,varargin)
% Create a cmd and run an elastic search from the search struct
%
%  [srchResult, srchFile] = st.search(s)
%
% Input:
%  srch:  A struct containing the url, token and json fields needed to
%         create the search command
%  srchFile:  Name of json file if you want it returned by the search
%
% Return:
%  srchResult:  Struct of data from scitran
%
% BW Scitran Team 2016

%% Could check the srch struct here for the appropriate fields
%
p = inputParser;

p.addRequired('srch');
% If you want the json file returned by the search, then this should be a
% legitimate file name for writing it.  It should have a .json extension.
p.addParameter('oFile','',@ischar);

p.parse(srch,varargin{:});
srch  = p.Results.srch;
oFile = p.Results.oFile;


%% The srch is a Matlab structure containing the search requirements. 

% It is converted to json here.  But, we accept either a struct or a json
% notation for the srch.
if isstruct(srch)
    % It is a Matlab struct, so convert it to json notation.
    srch = savejson('',srch);
end
esCMD = obj.searchCmd(srch);

% Could validate the oFile name
%vFunc = @(x) isequal(x(end-5:end),'.json');

%% Run the command

% result is a string with a bunch of stuff RF put in it, including timing
% information and the json output file.  We get the filename below.
[~, result] = system(esCMD);

% Load the result json file. NOTE the use of strtrim to get rid of the
% final blank character
srchFile = strtrim(result(strfind(result,'/private/tmp'):end));

% This is now a Matlab struct with a lot of ugly terms.  We clean them up
% below.
srchResult = loadjson(srchFile); 
if isfield(srchResult,'message')
    result = srchResult;
    fprintf('Search error\n');
    fprintf('Status code: %d\n',result.status_code);
    fprintf('Message:     %s\n',result.message);
    return;
end

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
    case 'files'
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
if strcmp(srchType,'files')
    n = length(result);
    for ii=1:n
        cname = result{ii}.source.container_name;
        acquisitionid    = result{ii}.source.acquisition.x0x5F_id;
        fname = result{ii}.source.name;
        result{ii}.plink = sprintf('%s/api/%s/%s/files/%s',obj.url, cname, acquisitionid, fname);
    end
end

% Save the search file, or delete it.
if ~isempty(oFile)
    % Less typical
    movefile(srchFile,oFile);
else
    % Typical
    delete(srchFile);
end



end
