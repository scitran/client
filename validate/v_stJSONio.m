% s_stJSONIO tests
%
% G. Flandin modified his Matlab JSONio repository to enable us to replace
% certain hex strings with protected characters in Matlab.
%
% We can place a 'dot' in a string and we can start a variable with an
% underscore. To do so requires placing the hex string in the Matlab
% variable, and then calling jsonwrite() with the 'replacementstyle','hex'
% arguments. See below.
%
% BW Scitran Team, 2017

%% Preserve the first underscore in a string (_id)
%
% Put x0x5F in the Matlab variable to lead with an underscore
%  Notice that the "_id" field starts with the underscore

clear srch
srch.projects.match.x0x5Fid = 111;
jsonwrite(srch,struct('indent','  ','replacementstyle','hex'))

%% Preserve the '.' in a string
%
% Put 0x2E in the Matlab variable to create a '.' (dot) in the JSON
% variable.

clear srch
srch.sessions.range.subject0x2Eage.gt = 1;
jsonwrite(srch,struct('indent','  ','replacementstyle','hex'))

% Notice that the subject.age field has a dot inside the variable name

%%