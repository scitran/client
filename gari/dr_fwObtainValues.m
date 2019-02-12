function VALUES = dr_fwObtainValues(st, thisAnalysis, measurement)
%DR_FWOBTAINVALUES Summary of this function goes here

% Now obtain the data itself (for example, for afq it coudl be fa
% profiles)
% FC: create a function that gives this value to be included in the
% dt, validates that exists, etc. 
fileName = ['AFQ_' measurement '.csv']; % I could not make it work wiht regex
fileURL  = '';
try 
    fileURL  = st.fw.getAnalysisOutputDownloadUrl(idGet(thisAnalysis), fileName);
catch 
    disp([fileName ' not found.'])
end
VALUES = [];
if ~isempty(fileURL)
    VALUES = readtable(...
                st.fw.downloadOutputFromAnalysis(...
                      idGet(thisAnalysis), ...
                      fileName, ...
                      fullfile(afqDimPath,'local','tmp',fileName)));
end



end

