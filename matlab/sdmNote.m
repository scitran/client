%% Add a note to a flywheel analysis object
%
%
%
% LMP/BW/RF  Vistasoft Team, 2016

%% Create the token
[token, furl, ~] = sdmAuth('action', 'create', 'instance', 'local');

%% Do a search for files in the collection

% Looking for zip files
clear jsonSend
jsonSend.multi_match.fields = '*';
jsonSend.multi_match.query = '.zip';
jsonSend.multi_match.lenient = 'true';

% Convert
jsonData = savejson('',jsonSend);

% Build up the curl command
clear s
s.url    = furl;
s.token  = token;
s.body   = jsonData;
s.target = 'files';
s.collection = 'patients';
srchCMD = sdmCommandCreate(s);
[~, result] = system(srchCMD);
scitranData = loadjson(result);

idx = sdmSearch(scitranData,'pField','subject code','value','ex8403')
% Here is an example
scitranData{idx(1)}
%% Make the note

myNote = 'Hello World';

%% 
furl
sessionID = scitranData{1}.session.x0x5F_id;
noteID    = scitranData{1}.session.notes{1}.x0x5F_id;

value = myNote;
payload = savejson(value);
cmd = sprintf('curl -X POST %s/api/sessions/%s/notes -k -d ''%s'' ', furl,sessionID,payload)
system(cmd)



COL_ID=`curl https://docker.local.flywheel.io:8443/api/collections -H "X-SciTran-Auth:change-me" -A "SciTran Drone Reaper" -k | jq -r '.[0]._id'`


PAYLOAD='{
    "label": "test_analysis",
    "files": [
        {"name": "bootstrap.json.sample"}
    ]
}'
AID=`curl -F "file=@bootstrap.json.sample" -F "metadata=$PAYLOAD" https://docker.local.flywheel.io:8443/api/collections/$COL_ID/analyses -H "X-SciTran-Auth:change-me" -A "SciTran Drone Reaper" -k | jq -r '._id'`

TICKET_ID=`curl https://docker.local.flywheel.io:8443/api/collections/$COL_ID/analyses/$AID/files -H "X-SciTran-Auth:change-me" -A "SciTran Drone Reaper" -k | jq -r '.ticket'`

curl https://docker.local.flywheel.io:8443/api/collections/$COL_ID/analyses/$AID/files?ticket=$TICKET_ID -H "X-SciTran-Auth:change-me" -A "SciTran Drone Reaper" -k > analyses.tar



curl -XGET "https://docker.local.flywheel.io:8443/api/search/files?collection=patient&user=renzofrigato@flywheel.io&root=1" -d'
{
          "multi_match": {
            "fields": "*",
            "query": ".zip",
            "lenient": true
          }
}' -k | jq .


