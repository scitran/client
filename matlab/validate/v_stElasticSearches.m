%% Use Elastic Search to Query the database
%
%    * Authorize - use stAuth to get a token
%    * Set database parameters (e.g., url and token)
%    * Set json parameters for the search
%    * Use stEsearchRun
% 
%  The scitran site url and token are fixed and set at the beginning. We
%  then illustrate how to set the fields of a Matlab struct to perform a
%  range of queries.  A more extensive manual will be prepared in the next
%  few weeks.
%
%
% Notes:
%  Matlab uses '.' in structs, and json allows '.' as part of the
%  variable name. So, we insert a dot on the Matlab side by inserting a
%  string, _0x2E_.  For example, to create a json object like this:
%
%   s = {
%   	"range": {
%   		"subject.age": {
% 	   		  "lte": 10
% 		    }
% 	       }
%       }
% We use the code
%
%     clear s; s.range.subject_0x2E_age.lte = 10;
%     json = savejson('',s)
%
% LMP/BW Scitran Team, 2016

%% Authorization

% The auth returns a token and the url of the flywheel instance
[token, furl, ~] = stAuth('action', 'create', 'instance', 'scitran');
fprintf('Token length %d\nConnected to: %s\n',length(token),furl)

% We use the structure s to store the parameters needed to create the
% elastic search command.  The url and token are fixed throughout, so we
% set them here.  

clear s
s.url    = furl;
s.token  = token;

% We keep changing the json payload, which we store in the slot called
%    s.json
% This is built up repeatedly for each of the searches, below.

%% get sessions created in the last 2 weeks

clear b
b.path = 'sessions';
b.sessions.range.created.gte = 'now-2w';
s.json = savejson('',b);
data = stEsearchRun(s);
fprintf('Found %d sessions in previous two weeks \n',length(data.sessions))

%% To see the session in the web page, use this command
stBrowser(s.url,data.sessions{1});

%% Get sessions with this subject code
clear b
b.path = 'sessions';
subjectCode = 'ex4842';
b.sessions.match.subject_0x2E_code = subjectCode;
s.json = savejson('',b);
data = stEsearchRun(s);
fprintf('Found %d sessions with subject code %s\n',length(data.sessions),subjectCode)

% Click to 'Subject' tab to see the subject code
%    stBrowser(s.url,data.sessions{1});

%% Find a session with this label

clear b
b.path = 'sessions';
sessionLabel = '20151128_1621';
b.sessions.match.label= sessionLabel;
s.json = savejson('',b);
data = stEsearchRun(s);
fprintf('Found %d sessions with the label %s\n',length(data.sessions),sessionLabel)

%%  
stBrowser(s.url,data.sessions{1});


%% Sessions with subjects within this age range

clear b
b.path = 'sessions';
b.range.subject_0x2E_age.lte = 12;
s.json = savejson('',b);
data = stEsearchRun(s); 

% I do not think this runs correctly.  The number is far too large.
fprintf('Found %d sessions with subjects in this range\n',length(data.sessions));

%% get files in acquisition

clear b
b.path = 'acquisitions/files';
b.projects.match.label = 'testproject';
b.sessions.match.label = '20120522_1043';
b.acquisitions.match.label = '11_1_spiral_high_res_fieldmap';
s.json = savejson('',b);
data = stEsearchRun(s);
fprintf('Found %d matches to this acquisition/files label\n',length(data.files));

% This is how to download the nifti file
fname = data.files{1}.x0x5F_source.name;
id    = data.files{1}.x0x5F_source.container_id;
sz    = data.files{1}.x0x5F_source.size;
plink = sprintf('%s/api/acquisitions/%s/files/%s',s.url, id, fname);
dl_file = stGet(plink, s.token, 'destination', fullfile(pwd,fname),'size',sz);

%% Show the session that contains this file

% Maybe there is a better way to get to the session with this file
clear b
b.path = 'sessions';
b.sessions.match.label = '20120522_1043';
s.json = savejson('',b);
data = stEsearchRun(s);
stBrowser(s.url,data.sessions{1});

%% Get the URL to the collection labeled Young Males

clear b
b.path = 'collections';   % The s needs to be trimmed, sigh.
b.collections.match.label = 'Young Males';
s.json = savejson('',b);
data = stEsearchRun(s);
stBrowser(s.url,data.collections{1});

%%
clear b
b.path = 'files';   % The s needs to be trimmed, sigh.
b.collections.match.label = 'Young Males';
b.acquisitions.match.label = 'SPGR 1mm 30deg';
b.files.match.type = 'nifti';
s.json = b;

data = stEsearchRun(s);
stBrowser(s.url,data.collections{1});

%%
clear b
b.path = 'files';   % The s needs to be trimmed, sigh.
b.collections.match.label = 'Young Males';
b.acquisitions.match.measurement = 'Diffusion';
b.files.match.type = 'bvec';
s.json = savejson('',b);
data = stEsearchRun(s);

data = stEsearchRun(s);

stBrowser(s.url,data.collections{1});

%% get files in project/session/acquisition/collection

clear b
b.path = 'files';
b.projects.match.label = 'ENGAGE';
b.sessions.match.label = '20160212_1145';
b.acquisitions.match.label = '14_1_HOS_WB_HRBRAIN';
s.json = savejson('',b);
[data,plinks] = stEsearchRun(s);

for ii=1:length(data.files)
    data.files{ii}.x0x5F_source.type
end


% Maybe there is a better way to get to the session with this file
% This works, but ...
clear b
b.path = 'sessions';
b.projects.match.label = 'ENGAGE';
b.sessions.match.label = '20160212_1145';
s.json = savejson('',b);
data = stEsearchRun(s);
stBrowser(s.url,data.sessions{1});

%% get files in project/session/acquisition/collection

clear b
b.path = 'files';                         % Looking for T1 weighted files
b.collections.match.label = 'ENGAGE';     % Collection is ENGAGE
% b.projects.match.label = 'ENGAGE';       
b.acquisitions.match.label = 'T1w 1mm';   % Description column
s.json = savejson('',b);
[data,plinks] = stEsearchRun(s);
fprintf('Found %d matching files\n',length(data.files))

%stBrowser(s.url,data.sessions{1});

%% get files from a collection

clear b
b.path = 'files';                         % Looking for T1 weighted files
b.collections.match.label = 'Young Males';   
% b.projects.match.label = 'ENGAGE';       
b.acquisitions.match.label = 'SPGR 1mm 30deg';   % Description column
b.files.match.name = '16.1_dicom_nifti.nii.gz';
% b.files.match.name = '*.nii.gz';

% b.acquisitions.match.type  = 'nifti';
s.json = savejson('',b);
data = stEsearchRun(s);
fprintf('Found %d matching files\n',length(data.files))

for ii=1:length(data.files)
    data.files{ii}.x0x5F_source
end

%% get all the projects
clear b
b.path = 'projects';
% b.sessions.match.label = '20151128_1621';
s.json = savejson('',b);
data = stEsearchRun(s);
fprintf('Found %d matching projects\n',length(data.projects))


