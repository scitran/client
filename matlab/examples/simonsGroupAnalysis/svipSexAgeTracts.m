%% Find boys between 10 and 20 years of age

%% Open up the scitran client

% This has a permission that is hidden.  The user obtains this permission
% by logging in to the site and using the UI
st = scitran('action', 'create', 'instance', 'scitran');

%%
clear srch
srch.path = 'sessions';
srch.projects.match.label = 'SVIP Released';
srch.sessions.bool.must{1}.range.subject_0x2E_age.gt = year2sec(10);
srch.sessions.bool.must{1}.range.subject_0x2E_age.lt = year2sec(20);
sessions = st.search(srch);


clear srch
srch.path = 'analyses/files';                  % Files within an analysis
srch.files.match.name = 'fa.csv';              % Result file
srch.projects.match.label = 'SVIP';            % Any of the Simons VIP data
srch.sessions.match.subject_0x2E_sex = 'male'; % Males
srch.sessions.bool.must{1}.range.subject_0x2E_age.gt = year2sec(10);
srch.sessions.bool.must{1}.range.subject_0x2E_age.lt = year2sec(20);

files = st.search(srch);

%%