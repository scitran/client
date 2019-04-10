
## List (Deprecated)
The new metadata objects make the List method obsolete.  This section is here for historical usage for a while, but it will be removed in six months (July 1, 2019).

The list method specifies two arguments.  The first is the type of object you would like to return; the second specifies the id of the container to list.  Listing is much like using 'dir' or 'ls' on a file system.

Continuing down the directory tree from group, project, session, acquisition, files

    projects     = st.list('project','wandell');
    sessions     = st.list('session',idGet(projects{5}));     % Pick one ....
    acquisitions = st.list('acquisition',idGet(sessions{1})); 
    files        = st.list('file',idGet(acquisitions{1})); 

**N.B.** The format of the structures in the list cell array differ from the structures returned by search.  We are producing helper functions to minimize the burden.  In this example, we use the utility function idGet(...), which returns the container id for either the list or search structs. We are hoping that Flywheel writes a function that will make it unnecessary to use idGet() in the near future.

st.objectParse to be explained here.  Reference the 'fw' option in the search.

Talk about 

* stModel.  
* stSearch2Container.

The scitran.list method is useful when you know the containers (project, session, acquisition or collection), and you want to list the container content. The list command returns a cell array, and each cell has the type of the object that you are listing.  For example, listing the sessions in a project returns a cell array of objects in the class _flywheel.model.Session_.