### Listing vs. Searching

The scitran **list** method is designed for the case when you know the ID of a container (project, session, acquisition or collection) and you want to list what is within it. The [list examples page](list-examples) demonstrates the usage.  One way to understand the information returned from a list or search is to explore the values in the returned Matlab structs.  You also might want to look at the [Flywheel data model](https://github.com/scitran/core/wiki/Data-Model) to see the definition of a term.

The scitran **search** method is very useful when you are processing data or searching to reuse data from many projects. The scitran **search** method returns a great deal of information about the container. To download the contents of a container use one of the get<>, download<> or read<> methods. 

To learn more about setting search parameter see [search examples on this page](search-examples) and an [m-file with many examples](https://github.com/scitran/client/blob/master/scripts/s_stSearches.m). The search method uses **elastic search**, an advanced method for searching large databases.  Elastic search is constantly indexing the data base, and the search is based on this index. For this reason, there may be some delay between the time when you modify the MongoDB itself, and when you can find the modification using elastic search. Typically, the time is fairly short - a few seconds or so. 

We recommend that if you know what you want and where it is, use **list**.  If you are exploring, particularly across many projects, use **search**.

**N.B.**  The data format returned by the **list** method differs from the data returned by the **search** method.  A great deal more metadata is returned by search.

### Brief introduction to search
The arguments to the search method specify (a) the type of object to return and (b) parameters that define the search. For example, to search for all the projects in the database you would use

    projects = st.search('project');

The first argument is a required string that defines the type of object you would like returned. The permissible strings are
```
'project','session','acquisition','file','collection', 'analysis','subject','note'
```

The other search parameters are in parameter/val format.  For example, to find a project with a particular label (case sensitive) use
```
vwfaProject = st.search(...
                'project',...
                'project label exact','VWFA');
```
or to find all the sessions in a specific project 
```
vwfaSessions = st.search(...
                 'session',...
                 'project label exact','VWFA');
```
To find partial label matches (case insensitive) use
```
project = st.search(...
             'project',
             'project label contains','vwfa');
```

## Search scope

By default, you search only the projects you have access to.  To search the entire database use argument

    projects = st.search('project','all_data',true);

You only have permission to view or download a subset of these, but you can learn about what is in the database from an 'all_data' search.



