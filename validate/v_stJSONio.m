% s_stJSONIO tests
%
% G. Flandin kindly wrote a condition so that when there is x0xVVV_ in the
% string it is replaced by the hex value of VVV
%
%

%% Preserve the first underscore in a string (_id)
% Put x0x5F_ in the string
clear srch
srch.projects.match.x0x5F_id = 111;
jsonwrite(srch,struct('indent','  ','replacementstyle','hex'))

%% Preserve the '.' in a string
%
% Put x0x2E_ in the string
%

clear srch
srch.sessions.range.subjectx0x2E_age.gt = 1;
jsonwrite(srch,struct('indent','  ','replacementstyle','hex'))

%%