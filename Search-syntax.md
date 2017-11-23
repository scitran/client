
The arguments to the search method specify (a) the type of object to return and (b) parameters that define the search. 

```
cellArray = st.search('objectTypeToReturn',...
               'Parameter',value, ...
                ...);
```
The 'objectTypeToReturn' can be one of these Flywheel data objects
```
objects = ...
{'file','acquisition','session','project','collection', 'analysis','subject','note'};
```

**cellArray** is a cell array of structures containing fields that are relevant to describe the database object.  For example, the cell array returned for a project is
```
>> projects{1}

ans = 

  struct with fields:

        project: [1×1 struct]
          group: [1×1 struct]
    permissions: [15×1 struct]
```
While the cell array for returned for a session is

```
>> sessions{1}

ans = 

  struct with fields:

        project: [1×1 struct]
          group: [1×1 struct]
        session: [1×1 struct]
        subject: [1×1 struct]
    permissions: [11×1 struct]
```

## Search parameters

The search method lets you specify many different parameters.  The list is far too long to (usefully) include here.  We think the best way for you to understand search is through [examples](Search-examples) and leafing through the [search method source code](https://github.com/scitran/client/blob/master/%40scitran/search.m).

The comments here provide information that might not be obvious and some general guidance.

## Search examples

See the searches illustrated in [s_stSearches.m](https://github.com/scitran/client/blob/master/scripts/s_stSearches.m). 





