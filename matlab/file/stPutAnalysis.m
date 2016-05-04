function curlCmd = stPutAnalysis(s, collection, upload)
% Store the data in json in the scitran database in s
%
%
% BW/LMP Scitran Team, 2016

%% Check input arguments

%% Build the command

% Store the collection id
id = collection.id;

% Construct the command to upload one input file and one output file
inAnalysis  = fullfile(pwd, 'input', upload.inputs{1}.name);
outAnalysis = fullfile(pwd, 'output',upload.outputs{1}.name);

% % We have to pad the json struct or savejson will not give us a list
if length(upload.inputs) == 1
    upload.inputs{end+1}.name = '';          
end
if length(upload.outputs) == 1
    upload.outputs{end+1}.name = '';
end

% Jsonify the payload, assuming it is necessary
if isstruct(upload)
    upload = savejson('',upload);
    upload = strrep(upload, '"', '\"');   % Escape the " or the cmd will fail.
end

curlCmd = sprintf('curl -F "file1=@%s" -F "file2=@%s" -F "metadata=%s" %s/api/collections/%s/analyses -H "Authorization":"%s"', inAnalysis, outAnalysis, upload, s.url, id, s.token );

%% Execute the curl command with all the fields

stCurlRun(curlCmd);

end