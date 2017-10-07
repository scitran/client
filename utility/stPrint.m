function stPrint(result,slot, field)
% Print the fields from a result to the command window
%
%
% Example
%   fw = scitran('vistalab');
%   projects = fw.search('project');
%   stPrint(projects,'project','label');
%
% BW, Scitran
%

p = inputParser;
p.addRequired('result',@iscell);
p.addRequired('slot',@ischar);
p.addRequired('field',@ischar);
p.parse(result,slot,field);

fprintf('\n %s %s\n-----------------------------\n',slot,field);
for ii=1:length(result)
    fprintf('\t%d - %s \n',ii,result{ii}.(slot).(field)); 
end

end