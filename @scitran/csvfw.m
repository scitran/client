function csvfw(st, header,data)
% Write a csv in the flywheel plotting format
%
% Syntax:
%     st.csvfw(data, header)
%
% Description:
%   RF created a special format for 
%

%{
% From the file example_viz_csv.csv
% Stored in the Collection, Visualization as an Attachment
%
x_ticks,column1,column2,column3,x_label,y_label,x_title,color_column1,color_column2,color_column3,style_column2
1.2,1.7241,0.81301,1.0204,label_for_x_axis,y_label,Arbie PSTH,#ff0000,#00ff00,#0000ff,dashed
1.2,2.7586,0.81301,1.0204
1.6,2.7586,1.2195,1.3605
%}
cHeader = {'x_ticks', 'frs_reward1_choice1' 'frs_reward1_choice2' 'frs_reward2_choice1' 'frs_reward2_choice2'};
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas

% Write header to csv file
psthFile = fullfile(baseDir, strcat(fileName, '_psth.csv'));
fid = fopen(psthFile,'w');
fprintf(fid,'%s\n',textHeader)
fclose(fid)

% Add the data
dlmwrite(psthFile, vertcat(tPlot(tIdx), squeeze((rValues(:,:,1,tIdx))), squeeze((rValues(:,:,2,tIdx))))','-append');

%%
