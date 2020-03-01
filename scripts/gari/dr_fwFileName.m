function fileName = dr_fwFileName(container, pattern, varargin)
% If we are working with members of a zip file, it will return them all in a
% cell array.
% If we are working with analysis or acquisitions, it will return the last one
% in a char array
if ismember('members',fieldnames(container))
    fileName = {};
    ii = 0;
    allFiles = container.members;
    for nf=1:length(allFiles)
        if contains(allFiles{nf}.path, pattern)
            ii=ii+1;
            fileName{ii} = allFiles{nf}.path;
        end
    end
else 
    fileName = [];
    if nargin < 3 || strcmp(varargin{1}, 'output')
        allFiles = container.files;
    else
        allFiles = container.inputs;
    end 
    
    if iscell(allFiles)
        for nf=1:length(allFiles)
            tmpName = allFiles{nf}.name;
            if contains(tmpName, pattern)
                fileName = tmpName;
            end
        end
    else
       for nf=1:length(allFiles)
            tmpName = allFiles(nf).name;
            if contains(tmpName, pattern)
                fileName = tmpName;
            end
        end    
    end
    
end
    

end



