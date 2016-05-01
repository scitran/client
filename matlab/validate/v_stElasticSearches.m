%% Use Elastic Search to Query the database
%
%    * Authorize - use stAuth to get a token
%    * Set base parameters (e.g., url and token)
%
% LMP/BW Scitran Team, 2016

% Notes
%
% When you want a dot in the search field, for example
%
% {
% 	"range": {
% 		"subject.age": {
% 			"gte": 10,
% 			"lte": 90
% 		}
% 	}
% }
% 
% You should insert the string "_0x2E_".   In subject.age you should have
% subject_0x2E_age.
%
% If you do not include subject.age, then all ages will be returned.
%
% Because this is ugly, we might use the syntax _dot_ and then do a
% strrep(). Also, notice that gte means greater than or equal to, and lte
% for less than or equal to.
% 
% I believe we might need a similar 


%% Authorization
% The auth returns both a token and the url of the flywheel instance
[token, furl, ~] = stAuth('action', 'create', 'instance', 'scitran');
fprintf('Token length %d\nConnected to: %s\n',length(token),furl)

% Build up the curl command.  We use s to denote the structure that
% contains the parameters used to create the elastic search command.
clear s
s.url    = furl;
s.token  = token;

%% Example searches from RF's search_demo.sh stored in local

% # get sessions created in the last 2 weeks
% curl -X GET $BASE_URL/search?user=$USERNAME\&root=true -k -d '{
%     "path": "sessions",
%     "sessions": {
%         "range": {
%             "created": {
%                 "gte":"now-2w"
%             }
%         }
%     }
% }' 
clear b
b.path = 'sessions';
b.sessions.range.created.gte = 'now-2w';
s.body = savejson('',b);
data = stEsearchRun(s);
fprintf('Found sessions in previous two weeks %d\n',length(data.sessions))

% Open up the browser to the first found session
id = data.sessions{1}.x0x5F_id;
webid = sprintf('%s/#/dashboard/%s/%s',s.url,b.path(1:(end-1)),id)
web(webid,'-browser')

% Get sessions with this subject code
% '{
%     "path": "sessions",
%     "sessions": {
%         "match": {
%             "subject.code": "ex7236"
%         }
%     }
% }'
%
clear b
b.path = 'sessions';
subjectCode = 'ex4842';
b.sessions.match.subject_0x2E_code = subjectCode;
s.body = savejson('',b);
data = stEsearchRun(s);
fprintf('Found %d sessions with subject code %s\n',length(data.sessions),subjectCode)

id = data.sessions{1}.x0x5F_id;
webid = sprintf('%s/#/dashboard/%s/%s',s.url,b.path(1:(end-1)),id);
web(webid,'-browser')

% Find a session with this label
clear b
b.path = 'sessions';
b.sessions.match.label= '20151128_1621';
s.body = savejson('',b);



% *****Fails.  Ask RF.*****
% # get files in acquisition
% curl -X GET $BASE_URL/search?user=$USERNAME\&root=true -k -d '{
%     "path": "acquisitions/files",
%     "projects": {
%         "match": {
%             "label": "Testdata"
%         }
%     },
%     "sessions": {
%         "match": {
%             "label": "baz"
%         }
%     },
%     "acquisitions": {
%         "match": {
%             "label": "screensave"
%         }
%     }
% }'
clear b
b.path = 'acquisitions/files';
b.projects.match.label = 'testproject';
b.session.match.label = '20120522_1043';
b.acquisitions.match.label = '*';
s.body = savejson('',b);
s.body


% Try to get the URL to the collections with the label Young Males
clear b
b.path = 'collections';   % The s needs to be trimmed, sigh.
b.collections.match.label = 'Young Males';
s.body = savejson('',b);
s.body
data = stEsearchRun(s);
id = data.collections{1}.x0x5F_id;
webid = sprintf('%s/#/dashboard/%s/%s',s.url,b.path(1:(end-1)),id);
web(webid,'-browser')


% # get files in project/session/acquisition/collection
% curl -X GET $BASE_URL/search?user=$USERNAME\&root=true -k -d '{
%     "path": "files",
%     "projects": {
%         "match": {
%             "label": "Testdata"
%         }
%     },
%     "sessions": {
%         "match": {
%             "label": "baz"
%         }
%     },
%     "acquisitions": {
%         "match": {
%             "label": "screensave"
%         }
%     }
% }'
clear b
b.path = 'files';
b.projects.match.label = 'ENGAGE';
b.sessions.match.label = '20160212_1145';
b.acquisitions.match.label = '14_1_HOS_WB_HRBRAIN';
s.body = savejson('',b);
s.body

data = stEsearchRun(s);

%% Now build the elastic search command

esCMD = stEsearchCreate(s);

%% Run the search 
[~, result] = system(esCMD);

% Load the result file
fname = strtrim(result(strfind(result,'/private/tmp'):end));
scitranData = loadjson(fname); % NOTE the use of strtrim

scitranData

%%
scitranData.sessions{1}.x0x5F_source

