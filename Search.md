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

By default, you are shown only the projects you have access to see.  To see all of the projects (or files or sessions or ...) use argument

    projects = st.search('project','all_data',true);

There are many types of searches; see [search examples on this page](search-examples) and an [m-file with many examples](https://github.com/scitran/client/blob/master/scripts/s_stSearches.m)



