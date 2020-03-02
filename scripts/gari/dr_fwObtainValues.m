function VALUES = dr_fwObtainValues(st, thisAnalysis, measurements)
%DR_FWOBTAINVALUES Summary of this function goes here

% Now obtain the data itself (for example, for afq it coudl be fa
% profiles)
% FC: create a function that gives this value to be included in the
% dt, validates that exists, etc. 

if ~iscell(measurements)
    measurements = {measurements};
end

for nm=1:length(measurements)
    measurement = measurements{nm};
    fileName = ['AFQ_' measurement '.csv']; % I could not make it work wiht regex
    fileURL  = '';
    try 
        fileURL  = st.fw.getAnalysisOutputDownloadUrl(idGet(thisAnalysis), fileName);
    catch 
        disp([fileName ' not found.'])
    end
    VALS{nm} = [];
    if ~isempty(fileURL)
        VALS{nm} = readtable(...
                    st.fw.downloadOutputFromAnalysis(...
                          idGet(thisAnalysis), ...
                          fileName, ...
                          fullfile(stRootPath,'local','tmp',fileName)));
    end
end



if nm==1
    VALUES = VALS{1};
else
    VALUES = VALS;
end
    


end

