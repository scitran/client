function [status, result] = put(obj,upType,stData,varargin)
% Put a file or an analysis to the scitran site
%
%   st.put(upType,stdata,'id',id)
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
%    st.put('analysis',stAnalysis,'id',collection{1}.id);
%    st.put('file',filename);
%
% LMP/BW Vistasoft Team, 2015-16


%% Parse inputs
p = inputParser;

% Maybe we can set upType here, before the check?
vFunc = @(x)(ismember(strrep(lower(x),' ',''),{...
    'projectanalysis', 'sessionanalysis', 'collectionanalysis',...
    'files','file',...
    }));
p.addRequired('upType',vFunc);

% Should have a vFunc here with more detail
p.addParameter('stAnalysis',[],@(x)(isequal(class(x),'stanalysis'))); 
p.addParameter('stFile',[],@isstruct);
p.addParameter('id','',@ischar);

p.parse(upType,stData,varargin{:});

upType     = strrep(lower(p.Results.upType),' ','');
stData     = p.Results.stFile;
stAnalysis = p.Results.stAnalysis;
id         = p.Results.id;


%% Do relevant upload
switch  upType
    case {'projectanalysis', 'sessionanalysis', 'collectionanalysis'}
        % Analysis upload.  Could be to a project, session, or collection
        % Perhaps we should just figure this out from the id.  Do we really
        % need to name it?  Maybe that is OK for clarity of the code?
        
        % Construct the command to upload input and output files of any
        % length % TODO: These should exist.
        % This should become a method, say 
        %   inAnalysis = analysis.inString;
        % and similarly below.
        inAnalysis = '';
        for ii = 1:numel(stAnalysis.inputs)
            inAnalysis = strcat(inAnalysis, sprintf(' -F "file%s=@%s" ', num2str(ii), stAnalysis.inputs{ii}.name));
        end
        
        % We have to pad the json struct or jsonwrite?? will not give us a list
        if length(stAnalysis.inputs) == 1
            stData.inputs{end+1}.name = '';
        end
        
        outAnalysis = '';
        for ii = 1:numel(stAnalysis.outputs)
            outAnalysis = strcat(outAnalysis, sprintf(' -F "file%s=@%s" ', num2str(ii + numel(stAnalysis.inputs)), stAnalysis.outputs{ii}.name));
        end
        % Again, pad
        if length(stAnalysis.outputs) == 1
            stData.outputs{end+1}.name = '';
        end

        % Remove full the full path, leaving only the file name, from input
        % and output name fields.  I guess that makes sense for the data up
        % on the scitran site.
        % analysis.stripPath;
        for ii = 1:numel(stAnalysis.inputs)
            [~, f, e] = fileparts(stAnalysis.inputs{ii}.name);
            stAnalysis.inputs{ii}.name = [f, e];
        end
        for ii = 1:numel(stAnalysis.outputs)
            [~, f, e] = fileparts(stAnalysis.outputs{ii}.name);
            stAnalysis.outputs{ii}.name = [f, e];
        end

        % Create the JSON data for the upload
        stData = stAnalysis.json;
        
        %         % Jsonify the payload (assuming it is necessary)
        %         if isstruct(stData)
        %             stData = jsonwrite(stData);
        %             % Escape the " or the cmd will fail.
        %             stData = strrep(stData, '"', '\"');
        %         end

        % Set the target for the analysis upload (collection or session)
        if contains(upType, 'collection'),  target = 'collections';
        elseif contains(upType, 'session'), target = 'sessions';
        else
            error('No analysis target. Options are: (1) Project Analysis, (2) Session Analysis (3) Collection Analysis')
        end

        curlCmd = sprintf('curl %s %s -F "metadata=%s" %s/api/%s/%s/analyses -H "Authorization":"%s"', inAnalysis, outAnalysis, stData, obj.url, target, id, obj.token );

        %% Execute the curl command with all the fields

        stCurlRun(curlCmd);

   case {'files','file'}

        % Not checked.  Do with LMP.

        if ~isfield(stData, 'id') || ~isfield(stData, 'file') || ~isfield(stData, 'containerType')
            error('field missing on stData');
        end
        containerType = stData.containerType;
        id = stData.id;
        file = stData.file;
        [~, fname, ext] = fileparts(file);
        fname = [fname, ext];
        if isfield(stData, 'metadata')
            metadata = jsonwrite(stData.metadata);
            % Escape the " or the cmd will fail.
            metadata = strrep(metadata, '"', '\"');
            metadata = sprintf('-F "metadata=%s"', metadata);
        else
            metadata = '';
        end
        %% Build and execute the curl command

        curl_cmd = sprintf('curl -s -F "file=@%s;filename=%s" %s "%s/api/%s/%s/files" -H "Authorization":"%s" -k',...
            file, fname, metadata, obj.url, containerType, id, obj.token);

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
