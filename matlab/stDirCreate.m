function stDirCreate(d)
% Create an empty directory, d
%
% LMP,BW Vistasoft Team, 2016

if exist(d,'dir'),     delete(fullfile(d,'*'))
else                   mkdir(d);
end

end