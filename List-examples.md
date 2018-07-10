The scitran **list** method returns the metadata for a specific container (project, session, acquisition, analysis or collection) 

This **list** method returns metadata about the container contents. The **downloadFile** and **downloadContainer** methods retrieve the data themselves. The **search** method returns containers or files from the whole database.

## Examples

Suppose you want a list describing the sessions in a particular project.
```
project      = st.search('project','project label exact','VWFA');
projectID    = idGet(project{1}, 'data type','project');
sessions     = st.list('session',projectID);
```
The search method returns a cell array of objects called flywheel.model.SearchResponse. These objects do not indicate whether the search was for a project or session or other container.  So, when we run the idGet() command, we had to tell the function that we are looking for the 'project' id.

This differs from the 'list' method.  In that case, the cell array that is returned has objects called flywheel.model.Project, or flywheel.model.Session.  In that case, you can call the simpler version of idget().

    projects     = st.list('project','wandell');
    sessions     = st.list('session',idGet(projects{1}));

Continuing down the directory tree, 

    acquisitions = st.list('acquisition',idGet(sessions{3})); 
    files        = st.list('file',idGet(acquisitions{1})); 

We expect that this difference will go away in a few weeks.  We have asked the flywheel folks to attach a 'searchType' parameter to the SearchResponse, so we will not have to specify the data type for search responses.


