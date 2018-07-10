function analysisInfo = analysisInfoGet(obj,id)
% Get the analysis information container
%
% BW Vistasoft 2019

%{
  st = scitran('stanfordlabs');
  analysis = st.search('analysis','project label exact','Brain Beats');
  clear a
  for ii=1:length(analysis)
     id = idGet(analysis{ii},'data type','analysis')
     a{ii} = st.analysisInfoGet(id);
  end

  for ii=1:length(a)
     fprintf('\n\n\n  **  %s ** \n',a{ii}.label);
     fprintf('  ** Configuration ** \n');
     disp(a{ii}.job.config.config)
  end

  % Create json data
  j = cell(length(a),1);
  for ii=1:length(a)
      j{ii} = jsonwrite(a{ii}.job.config.config);
      j{ii}
  end
%}

% We might want to let the input be an analysis structure.
analysisInfo = obj.fw.getAnalysis(id);

end

