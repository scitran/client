When you wish a listing of the objects in a particular project, session, acquisition, or collection you should use the scitran **listObjects** method.  This is faster than search and is more likely to return descriptions of only the data objects you want.

The data returned listObjects has a different format from the data returned by search.  There is a reason - but I have no intention of defending this behavior!  I am considering what to do about this.

## Example listings

Suppose you want a list describing the sessions in a particular project.
```
project      = st.search('project','project label exact','VWFA');
sessions     = st.listObjects('session',project{1}.project.x_id);
```
Or suppose you want to find the projects within a particular group

    projects     = st.listObjects('project','wandell');

Be aware that the cell array returned by listObjects differs from that returned by search.  In the **listObject** case the projectID is found by projects{1}.id, rather than projects{1}.project.x_id.

    sessions     = st.listObjects('session',projects{1}.id);

Continuing down the directory tree, 

    acquisitions = st.listObjects('acquisition',sessions{3}.id); 
    files        = st.listObjects('file',acquisitions{1}.id); 

To search the collections we use the curator, which is typically an email

    collections  = st.listObjects('collection','wandell@stanford.edu');
    sessions     = st.listObjects('collectionsession',collections{1}.id);
    acquisitions = st.listObjects('collectionacquisition',collections{1}.id); 


