The scitran **list** method returns the metadata for a specific container (project, session, acquisition, analysis or collection) 

This **list** method returns metadata about the container contents. The **downloadFile** and **downloadContainer** methods retrieve the data themselves. The **search** method returns containers or files from the whole database.

## Examples

### Containers

Suppose you want a list of projects, sessions or acquisitions.  You specify the type of container and the id of the parent container that contains what you are looking for.

    projects     = st.list('project','wandell');    % The parent is the group
    sessions     = st.list('session',idGet(projects{1}));   % The parent is this first project
    acquisitions = st.list('acquisition',idGet(sessions{3})); 
    files        = st.list('file',idGet(acquisitions{1})); 

You can also start with a search, and then list

```
project      = st.search('project','project label exact','VWFA');
projectID    = idGet(project{1}, 'data type','project');
sessions     = st.list('session',projectID);
```

The search method returns a cell array of objects called flywheel.model.SearchResponse. These objects do not indicate whether the search was for a project or session or other container.  So, in this case when we run the idGet() command, we had to tell the function that we are looking for the 'project' id.

This differs from the 'list' method.  In that case, the cell array that is returned has objects called flywheel.model.Project, or flywheel.model.Session.  In that case, you can call the simpler version of idGet(). We have asked the Flywheel folks to attach a 'searchType' parameter to the SearchResponse, and that way we will not have to specify the data type for the idGet() on a SearchResponse.

### The projectHierarchy method

```
st.projectHierarchy(projectID)
```

