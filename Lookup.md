When you know about the metadata of a specific container or file, you can retrieve it using scitran.lookup.  This methods is similar to the Unix 'ls' command; or, if you prefer, to the Windows 'dir' command.  

The methods **find** and **findFirst** are useful if you would like to select a session or acquisition from a project. 

See the script **s_stLookup** for examples.

## Lookup - container
To retrieve metadata about a group, project, session, acquisition or gear use **scitran.lookup**.  The method takes a string as input and returns the metadata object.  The lookup string describes the location of the metadata in the hierarchy, and it must be built in this order

    str = 'group/projectLabel/subjectCode/sessionLabel/acquisitionLabel';

You can stop at any level.  A convenient way to build up the string is this:

    lookupString=fullfile(groupID, projectLABEL, subjectCODE, sessionLABEL, acquisitionLABEL);
    thisContainer = st.lookup(lookupString);

## Lookup - file

The lookup method extends to the file level, but you must insert the string 'file', as in

    fName = 'fileName';
    lookupString = sprintf('%s/files/%s',lookupString,fName);
    thisFile = st.lookup(lookupString);

## Lookup - gear

    lookupString = fullfile('gear',gearName);
    st.lookup(lookupString);

## Lookup example
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

## find and findFirst
Metadata objects have methods to return their 'children'. For example, all the sessions in a project can be returned using
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
If you just want one session, and you don't care which one, you can use

```
>> thisSession = project.sessions.findFirst;
```
There are analogous functions for the session and acquisition levels.  Files have no children.
