%%  Compare the FA on an individual tract of different SVIP groups
%
%    1.  Search to find all the CSV files of AFQ for male subjects
%    2.  Pull out the FA tract profile of a particular tract
%    3.  Do the same for all female subjects in the SVIP data set
%    4.  Plot and compare the two distributions
%
% RF/BW PoST Team 2016

%% Open up the scitran client

% This has a permission that is hidden.  The user obtains this permission
% by logging in to the site and using the UI
st = scitran('action', 'create', 'instance', 'scitran');

%% Set up the search structure

% We are looking for files that 
%   * File:  is part of the AFQ analysis output
%   * File:  string ends in csv
%   * Project: part of the Simons VIP project
%   * Subject: is male

clear srch
srch.path = 'analyses/files';                % Files within an analysis
srch.files.match.name = 'fa.csv';            % Result file
srch.projects.match.label = 'SVIP';          % Any of the Simons VIP data
srch.sessions.match.subject_0x2E_sex = 'male'; % Males
maleFiles = st.search(srch);
fprintf('Found %d files\n',length(maleFiles));

%%
clear srch
srch.path = 'analyses/files';                % Files within an analysis
srch.files.match.name = 'fa.csv';            % Result file
srch.projects.match.label = 'SVIP';          % Any of the Simons VIP data
srch.sessions.match.subject_0x2E_sex = 'female'; % Males
femaleFiles = st.search(srch);
fprintf('Found %d files\n',length(femaleFiles));

%%
st.get(femaleFiles{1},'destination','female.csv');
d = csvread('female.csv');

