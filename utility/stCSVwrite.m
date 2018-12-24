function fname = stCSVwrite(fname, header, data, params)
% Write a csv file in the flywheel plotting format
%
% Syntax:
%     fullpathFname = stCSVwrite(fname, header, data, params)
%
% Description:
%   Write a CSV file in a special format (created by Renzo Frigato) so that
%   Flywheel plots tick marks, labels and controls line styles.
%
% Inputs:
%   header:  Cell array of strings
%   params:  Params string/value pairs 
%            x_label,y_label,x_title,color_column1 ... style_column1 ...
%            Collors are ##ff0000 style.  Not sure how to interpret
%            style_columnX might be 'dashed'
%   data:    Matrix of numbers
%
% Optional key/value pairs
%   N/A  -  Probably we should make params these pairs
%
% Returns
%   Output file (full path)
%
% Wandell, SCITRAN Team, 2018
%
% See also
%   stCSVcatcomma
%

%{
% No spaces are allowed in the text fields at the top.  Geez.
% From the file example_viz_csv.csv
% Stored in the Collection, Visualization as an Attachment
%
x_ticks,column1,column2,column3,x_label,y_label,x_title,color_column1,color_column2,color_column3,style_column2
1.2,1.7241,0.81301,1.0204,label_for_x_axis,y_label,Arbie PSTH,#ff0000,#00ff00,#0000ff,dashed
1.2,2.7586,0.81301,1.0204
1.6,2.7586,1.2195,1.3605
%}

%Examples:
%{

% Full params
header = {'x_ticks','var1','var2'};
params ={'x_label','XLABEL','y_label','YLABEL','x_title','XTITLE','style_column1','dashed'};
idx = (1:5)'; data = rand(5,2); data = [idx, data];
fname = 'deleteMe.csv';
fname = stCSVwrite(fname,header,data,params);

type(fname)

delete(fname);

% Without the params
fname = stCSVwrite(fname,header,data);
type(fname)

%}

%% Check parameters

if notDefined('header') || ~iscell(header), error('Header required'); end
if notDefined('data')   || ~ismatrix(data), error('Matrix data required'); end   
if notDefined('params'), params = []; end

%%  Complicated because there may or may not be parameters
cHeader  = stCSVcatcomma(header);
if ~isempty(params)
    cHeaderP = stCSVcatcomma(params(1:2:end));
    cHeader  = [cHeader,',',cHeaderP];
    cValues  = stCSVcatcomma(params(2:2:end));
    % Put the numbers and parameters on row 2
    numeric = strsplit(num2str(data(1,:)),' ');
    row2    = [stCSVcatcomma(numeric),',',cValues];
end

% Write header to csv file
fid = fopen(fname,'w');
fprintf(fid,'%s\n',cHeader);
if ~isempty(params), fprintf(fid,'%s\n',row2); end
fclose(fid);

% Add the data
if ~isempty(params)
    dlmwrite(fname, data(2:end,:),'-append');
else
    dlmwrite(fname, data,'-append');
end

fname = which(fname);

end
