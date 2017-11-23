## Brief overview

To perform a search on a Flywheel database, you must obtain [authorization](https://github.com/scitran/client/wiki/Authorization).  

    st = scitran('<your site name.');  % For example, st = scitran('vistalab');

The st.search() command specifies the type of database object you are searching for and search parameter limits.  Suppose you are searching for a project.  Then you would specify

    projects = st.search('projects');

The first field is required and it is a string that defines the type of object you would like returned. 
```
objectType = ...
{'file','acquisition','session','project','collection', 'analysis','subject','note'};
```

The remaining parameters are in parameter/val format that define the search parameters. 
```
projects = st.search('project',...
    'summary',true,...
    'project label exact','VWFA');
```

There are many types of searches; see [search examples on this page](search-examples) and an [m-file with many examples](https://github.com/scitran/client/blob/master/scripts/s_stSearches.m)

## Search scope

By default, you search only the projects you have access to.  To search the entire database use argument

    projects = st.search('project','all_data',true);

You only have permission to view or download a subset of these, but you can learn about what is in the database from an 'all_data' search.



