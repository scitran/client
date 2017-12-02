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

Be aware that the cell array returned by listObjects differs from that returned by search.  In the **listObject** case the projectID is found by projects{1}.id, rather than projects{1}.project.x_id.

    sessions     = st.list('session',projects{1}.id);

Continuing down the directory tree, 

    acquisitions = st.list('acquisition',sessions{3}.id); 
    files        = st.list('file',acquisitions{1}.id); 

To search the collections we use the curator, which is typically an email

    collections  = st.list('collection','wandell@stanford.edu');
    sessions     = st.list('collection session',collections{1}.id);
    acquisitions = st.list('collection acquisition',collections{1}.id); 



