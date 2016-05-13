function [status, result] = put(obj,upType,stData,varargin)
% Attach a file to the permalink location
%
%      st.put(upType,stdata,'id',id)
%
% Inputs:
%  upType: Type of upload.  Analysis, File, ...
%  stData: Matlab struct containing the fields for the upload
%
% Outputs:
%  status:  Boolean indicating success (0) or failure (~=0)
%  result:  The output of the verbose curl command
%
% We need to make sure the struct for the stData are described properly
% here.
%
% Example:
%    st.put('analysis',stData,'id',collection{1}.id);
%    st.put('file',stData);
%
% LMP/BW Vistasoft Team, 2015-16


%% Parse inputs
p = inputParser;
p.addRequired('upType',@ischar);

% Should have a vFunc here with more detail
p.addRequired('stData',@isstruct);
p.addParameter('id','',@ischar);

p.parse(upType,stData,varargin{:});

upType = p.Results.upType;
stData = p.Results.stData;
id     = p.Results.id;

%% Do relevant upload
switch upType
    case 'analysis'
        
        % Analysis upload to a collection or session.
        % In this case, the id needed to be set
        
        % Construct the command to upload one input file and one output file
        inAnalysis  = fullfile(pwd, 'input', stData.inputs{1}.name);
        outAnalysis = fullfile(pwd, 'output',stData.outputs{1}.name);
        
        % We have to pad the json struct or savejson will not give us a list
        if length(stData.inputs) == 1
            stData.inputs{end+1}.name = '';
        end
        if length(stData.outputs) == 1
            stData.outputs{end+1}.name = '';
        end
        
        % Jsonify the payload, assuming it is necessary
        if isstruct(stData)
            stData = savejson('',stData);
            stData = strrep(stData, '"', '\"');   % Escape the " or the cmd will fail.
        end
        
        curlCmd = sprintf('curl -F "file1=@%s" -F "file2=@%s" -F "metadata=%s" %s/api/collections/%s/analyses -H "Authorization":"%s"', inAnalysis, outAnalysis, stData, obj.url, id, obj.token );
        
        %% Execute the curl command with all the fields
        
        stCurlRun(curlCmd);
        
   case {'files','file'}
        
        % Not checked.  Do with LMP.
        
        % Handle permalinks which may have '?user='
        pLink = strsplit(pLink, '?');
        pLink = pLink{1};
        
        % Build the url from the permalink by removing the endpart
        url = fileparts(pLink);
        
        % Get the URL with the file name appended to it
        [~,n,e] = fileparts(fName);
        urlAndName = fullfile(url,[n,e]);
        
        
        %% Gemerate MD5 checksum
        
        % MAC
        if ismac
            md5_cmd = sprintf('md5 %s',fName);
            [md5_status, md5_result] = system(md5_cmd);
            checkSum = md5_result(end-32:end-1);
            
            % Linux
        elseif (isunix && ~ismac)
            md5_cmd = sprintf('md5sum %s',fName);
            [md5_status, md5_result] = system(md5_cmd);
            checkSum = md5_result(1:32);
            
            % Other/Unknown
        else
            error('Unsupported system.\n');
        end
        
        % Check that it worked
        if md5_status
            error('System checksum command failed');
        end
        
        
        %% Build and execute the curl command
        
        curl_cmd = sprintf('/usr/bin/curl -v -X PUT --data-binary @%s -H "Content-MD5:%s" -H "Content-Type:application/octet-stream" -H "Authorization:%s" "%s?flavor=attachment"\n', fName, checkSum, token, urlAndName);
        
        % Execute the command
        fprintf('Sending... ');
        [status, result] = stCurlRun(curl_cmd);
        
        % Let the user know if it worked
        if status
            warning('Upload failed');
            disp(result)
        else
            fprintf('File sucessfully uploaded.\n');
        end
        
     otherwise
        error('Unknown upload type %s\n',upType);
end

end
