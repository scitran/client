When you know about the existence and location of project containers and files, you can retrieve them using scitran.lookup.  This methods is similar to the Unix 'ls' command; or, if you prefer, to the Windows 'dir' command.  See the script **s_stLookup** for examples.

## Lookup
To retrieve metadata about a group, project, session, acquisition or fear use **scitran.lookup**.  The method takes a string as input and returns the metadata object.  The string should be formatted as

    lookupString=fullfile(groupID, projectLABEL, subjectCODE, sessionLABEL, acquisitionLABEL);
    st.lookup(lookupString);

Or

    lookupString = fullfile('gear',gearName);
    st.lookup(lookupString);

For example,
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
Using the metadata object, you can continue to learn more about its 'children'. For example, a cell array of the metadata for all the sessions in this project can be read using
```
>> sessions = project.sessions();
>> numel(sessions)

ans =

   114
```
To find a session with a particular label, use the **find** method
```
>> project.sessions.find('label=20151127_1332')

ans =

  1×1 cell array

    {1×1 flywheel.model.Session}
```
