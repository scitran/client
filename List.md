* [List examples](List-examples)

***
When you know about the existence and location of project containers and files, you can retrieve them using scitran.lookup or scitran.list.  These methods are similar to the Unix 'ls' command; or, if you prefer, to the Windows 'dir' command.

## Lookup
To read the metadata about a project, session, or acquisition you can use the **scitran.lookup** method.  It takes a string as input and returns the metadata object.  For example,
```
>> project = st.lookup('wandell/VWFA');
>> project

project = 

  ResolverProjectNode with properties:

         public: 0
          label: 'VWFA'
           info: [1×1 flywheel.model.CommonInfo]
    description: 'Visual word form area in adult.'
          group: 'wandell'
             id: '56e9d386ddea7f915e81f703'
        parents: [1×1 flywheel.model.ContainerParents]
     infoExists: []
        created: 16-Mar-2016 21:43:34
       modified: 31-Jul-2018 00:50:12
      templates: []
    permissions: {16×1 cell}
          files: []
          notes: {[1×1 flywheel.model.Note]}
           tags: {'newtag'}
       analyses: []
```
The metadata objects have methods, as well.  For example, if you would like a cell array of all the metadata of the sessions in this project, you can use
```
>> sessions = project.sessions();
>> numel(sessions)

ans =

   114
```
If you would like to find one session with a particular label, you can use the **find** method
```
>> project.sessions.find('label=20151127_1332')

ans =

  1×1 cell array

    {1×1 flywheel.model.Session}
```

## List
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