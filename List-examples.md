There are times when you want a listing of the containers and files in a particular project, session, acquisition or collection. The scitran **list** method returns a list of the metadata within a container. Search returns information about containers or files that may not have a single parent, but rather can be spread across the whole database.

This list and search methods both return metadata, while the downloadFile method retrieves the file itself.  The **list** method is faster than **search** and is more likely to return descriptions of only the data objects you want.

## Data format

The data returned by **list** has a different format from the data returned by **search**.  There is a reason - but I have no intention of defending this behavior!  I am considering what to do about this.

## Examples

Suppose you want a list describing the sessions in a particular project.
```
project      = st.search('project','project label exact','VWFA');
projectID    = idGet(project{1});
sessions     = st.list('session',projectID);
```
Or suppose you want to find the projects within a particular group

    projects     = st.list('project','wandell');

Be aware that the cell array returned by listObjects differs from that returned by search.  In the **listObject** case the projectID is found by projects{1}.id, rather than projects{1}.project.x_id.  You can reduce your programming burden by calling the utility function idGet(...), which returns a container id for either format.

    sessions     = st.list('session',idGet(projects{1}));

Continuing down the directory tree, 

    acquisitions = st.list('acquisition',idGet(sessions{3})); 
    files        = st.list('file',idGet(acquisitions{1})); 

To search the collections **IN PROGRESS DOCUMENTATION**




