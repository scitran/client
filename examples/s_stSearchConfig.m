%%
st = scitran('stanfordlabs');
st.verify;

%%
[collections, srchCmd] = st.search('collection',...
    'collection label contains','FWmatlabAPI_test',...
    'summary',true);

srchCmd.filters{2}.term.life_num_iterations = 100;
limit = 100;
srchResult = st.fw.search(srchCmd,'size',num2str(limit)); %.results;
