* [List examples](List-examples)
* [Search examples](Search-examples)
* [Special searches](Special-search-parameters)

***

### Listing vs. Searching

The scitran **list** method is useful when you know the ID of a container (project, session, acquisition or collection) and you want to list what is within it. The [list examples page](list-examples) demonstrates the usage.  One way to understand the information returned from a list or search is to explore the values in the returned Matlab structs.  You also might want to look at the [Flywheel data model](https://github.com/scitran/core/wiki/Data-Model) to see the definition of a term.

The scitran **search** method is useful when you are planning to find and analyze data from existing projects. The scitran **search** method returns a great deal of information about the file or container. To learn more about setting search parameter see [search examples on this page](search-examples) and an [m-file with many examples](https://github.com/scitran/client/blob/master/scripts/s_stSearches.m). 

If you know what you want and where it is, use **list**.  If you are exploring, use **search**.

## Listing
The list method specifies two arguments.  The first is the type of object you would like to return; the second specifies the id of the container to list.  Listing is much like using 'dir' or 'ls' on a file system.

Continuing down the directory tree from group, project, session, acquisition, files

    projects     = st.list('project','wandell');
    sessions     = st.list('session',idGet(projects{5}));     % Pick one ....
    acquisitions = st.list('acquisition',idGet(sessions{1})); 
    files        = st.list('file',idGet(acquisitions{1})); 

**N.B.** The format of the structures in the list cell array differ from the structures returned by search.  We are producing helper functions to minimize the burden.  In this example, we use the utility function idGet(...), which returns the container id for either the list or search structs. We are hoping that Flywheel writes a function that will make it unnecessary to use idGet() in the near future.

### Searching
The arguments to the search method specify (a) the type of object to return and (b) parameters that define the search. For example, to search for all the projects in the database you would use

    projects = st.search('project');

The first argument (required) specifies the type of object you would like returned. The permissible strings are
```
'project','session','acquisition','file','collection', 'analysis','subject','note'
```

The additional search parameters are in parameter/val format and specify properties of the object.  For example, to find a project with a particular label (case sensitive) use
```
vwfaProject = st.search('project',...
                'project label exact','VWFA');
```
or to find all the sessions in a specific project 
```
vwfaSessions = st.search('session',...
                 'project label exact','VWFA');
```
To find partial label matches (case insensitive) use
```
project = st.search('project',...
             'project label contains','vwfa');
```
There are a great many possible parameters for the **search** method. See the [search examples page](Search-examples).

### Search scope

By default, you search only the projects you have access to.  To search the entire database use argument

    projects = st.search('project','all_data',true);

You only have permission to view or download a subset of these, but you can learn about what is in the database from an 'all_data' search.

## Details

### Search implementation
The search method uses **elastic search**, an advanced method for searching large databases.  Elastic search is constantly indexing the data base, and the search is based on this index. For this reason, there may be some delay between the time when you modify the MongoDB itself, and when you can find the modification using elastic search. Typically, the time is fairly short - a few seconds or so. 

### Formats
The data format returned by the **list** method differs from the data returned by the **search** method.  A great deal more metadata is returned by search.



