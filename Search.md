## Brief overview

Searching a Flywheel database is very useful when you are processing data or searching to reuse data from many projects. Searches can be performed using the scitran **search** method.  The arguments to this method specify (a) the type of database object you are searching for and (b) search parameter limits.  

For example, to search for all the projects in the database you would use

    projects = st.search('project');

The first argument is a required string that defines the type of object you would like returned. The permissible strings are
```
'file','acquisition','session','project','collection', 'analysis','subject','note'
```

The other search parameters are in parameter/val format.  For example, to find a project with a particular label you would use
```
vwfaProject = st.search('project',...
    'project label exact','VWFA');
```
or to find all the sessions in a project you would use
```
vwfaSessions = st.search('session',...
    'project label exact','VWFA');
```

There are many search parameters. To learn more about these see [search examples on this page](search-examples) and an [m-file with many examples](https://github.com/scitran/client/blob/master/scripts/s_stSearches.m).

## Search scope

By default, you search only the projects you have access to.  To search the entire database use argument

    projects = st.search('project','all_data',true);

You only have permission to view or download a subset of these, but you can learn about what is in the database from an 'all_data' search.



