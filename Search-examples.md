The syntax for the Matlab search is to create a scitran object and then use the scitran.search() method.

    st = scitran('vistalab')

The first field defines the type of object you would like returned. The remaining arguments define the search parameters as parameter-value pairs. The returned object is a cell array of one of these types of objects

Returned objects are typically one of these: 'projects', 'sessions', 'acquisitions', 'files', 'collections', 'analyses', 'subjects', though there are a few other forms described later.

    projects = st.search('projects');

By default, you are shown only the projects you have access to see.  To see all of the projects (or files or sessions or ...) use argument

    projects = st.search('projects','all_data',true);

## Examples

There are many possible search parameters in `scitran.search()`. The script [s_stSearches.m](https://github.com/scitran/client/blob/master/scripts/s_stSearches.m) contains a series of more than 10 examples.  We describe some additional examples here, and you can find search used in many of the scitran scripts and examples.

To find all the projects with a particular label you can invoke

    project = st.search('projects','project label','VWFA');
    project = st.search('projects','project label contains','VWFA');



