The syntax for the Matlab search is to create a scitran object and then use the scitran.search() method.

    st = scitran('acgtion','create','instance','scitran')

The first field defines the type of object you would like returned. The remaining arguments define the search parameters as parameter-value pairs. The returned object is a cell array of one of these types of objects

    %   'projects','sessions','acquisitions','files','collections', 'analyses', or 'subjects'
    projects = st.search('projects');       % All the projects you have access to see

There are many additional search parameters defined in the header of scitran.search(). For example, to find all the projects with a particular label you can invoke

    project = st.search('projects','project label','VWFA');
    project = st.search('projects','project label contains','VWFA');


