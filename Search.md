* [Search examples](Search-examples) and [More search examples](https://github.com/scitran/client/blob/master/scripts/s_stSearches.m)
* [Special searches](Special-search-parameters)
* The 'fw', 'limit' and 'summary' options

***

The **scitran.search** method is useful when you are looking to find data of a particular type. For example, you may be interested to know how many examples of a T1 anatomical measurement are present in the database for men between 20 and 30 years of age. Or, how many diffusion weighted scans are there for women older than 50?  

The search command returns a cell array, and each cell has the type _flywheel.model.SearchResponse_.  This is a type of Matlab struct that contains great deal of information about the found objects. An example of one of the SearchResponse objects is 

```
Illustrate here
```

Notice that the object describes the object that was sought in the 'returnType' field. The SearchResponse does not contain all of the information about the object, which can be found by using scitran.lookup or scitran.list.  It does contain some additional information, however, say about the 'parent' fields of the returned object.

If you know what you want and where it is, use **scitran.list** or **scitran.lookup**.  If you are exploring, say to create a Collection for data reuse, or to prepare a summary of the data available for machine-learning experiments, then use**scitran.search**.

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

### Search return
The SearchResponse and the Flywheel database object contain different information.  If you are searching for only a few files, you may want the return to be in the format of the Flywheel object rather than the search response.  The scitran method stSearch2Container uses the information in the SearchResponse to list the container.  If that is what you really want, then you can use the 'fw' option to return a cell array of Containers rather than a cell array of SearchResponses.

     projectContainers = st.search('project','group label','wandell','fw',true);

## Wonkish

### Search implementation
The search method uses [**elastic search**](https://www.elastic.co/), an advanced method for searching large databases.  Elastic search is constantly indexing the data base, and the search is based on this index. For this reason, there may be some delay between the time when you modify the MongoDB itself, and when you can find the modification using elastic search. Typically, the time is fairly short - a few seconds or so. 

Flywheel is about to provide a means for querying whether the indexing is done, or perhaps the system has received a lot of new data or been rebooted and is currently very active.  This information will be shown in the browser interface and perhaps be made available through the Flywheel-SDK.



