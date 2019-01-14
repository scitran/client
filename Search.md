* [Search examples](Search-examples) and [More search examples](https://github.com/scitran/client/blob/master/scripts/s_stSearches.m)
* [Special searches](Special-search-parameters)

***

### Searching

The scitran **search** method is useful when you are trying to find data. The scitran **search** method returns a great deal of information about the object it found. The search command returns a cell array, and each cell has the type _flywheel.model.SearchResponse_.  

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
There are a great many possible key/value parameters for the **search** method. See the [search examples page](Search-examples).

### Search scope

By default, you search only the projects you have access to.  To search the entire database use argument

    projects = st.search('project','allData',true,'summary',true);

You only have permission to view or download a subset of these, but you can learn about what is in the database from an 'allData' search.  The Stanford Labs site will soon have more than 100 projects.

## Wonkish

### Search implementation
The search method uses [**elastic search**](https://www.elastic.co/), an advanced method for searching large databases.  Elastic search is constantly indexing the data base, and the search is based on this index. For this reason, there may be some delay between the time when you modify the MongoDB itself, and when you can find the modification using elastic search. Typically, the time is fairly short - a few seconds or so. 

### Formats
The class of the objects returned by **list** and  **search** differ. The list command returns objects within the class that you are listing.  The search returns a generic (searchResponse) class.  This difference can lead to some challenges in calling scitran methods.  In particular, we would like to know the class of the returned object when we use it as a parameter to other scitran methods. 

This is known to you, as a programmer, because when you run a search you specify the type of container or file that you are searching for.  But that information is not saved in the searchResponse class. We have asked Flywheel to provide us with a modification of the searchResponse class that includes this information.  That will greatly simplify some of the methods in **scitran**.

