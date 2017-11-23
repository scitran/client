The search method returns a wealth of information about the Flywheel database objects. The best way to understand the information is to perform a few searches and explore the returned values.  In some cases, you might want to look at the [Flywheel data model](https://github.com/scitran/core/wiki/Data-Model) to see the definition of a term.

To perform a search, first create a scitran Matlab object that is authorized to interact with your database (see [Authorization](Authorization)).  Then run

    st = scitran('vistalab');

The search method syntax is
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

## Groups
It is possible to use the term 'group' to retrieve information about the group, such as its projects and users. For example, to find the list of groups use

    st.search('group','all')

## Utility parameters

* 'summary'  - A logical that indicates whether to print how many objects were found
* 'all_data' - Run the search across the entire database; you cannot query or download objects without permission
* 'limit'    - Set a maximum number of returned objects (default is 10,000)

## Labels and names

Most objects are described by a **label**.  There is one exception, however.  When we search for files we search on the **name**, not the **label**.

## Contains and matches exactly

When searching for some parameters, including label or name, you can ask that the object match the label exactly or that that label contains a string.   For example, on the vistalab site we have a project with the label 'VWFA' and several other projects that include 'VWFA' in the label.  

When we search for a project label 'VWFA', we assume an exact match.

```
>> projects = st.search('projects','project label','VWFA');
>> length(projects)
ans =
     1
>> projects{1}.source.label
ans =
    'VWFA'
```

It is possible to find all the projects that contain the string 'VWFA' as well.

```
>> projects = st.search('projects','project label contains','VWFA');
>> for ii=1:length(projects), disp(projects{ii}.source.label); end
VWFA
VWFA FOV
VWFA FOV Hebrew
```
The exact vs. contains options are also used for labels describing session, analysis, acquisition, collection, and the file **name**.

## Search examples

See the searches illustrated in [s_stSearches.m](https://github.com/scitran/client/blob/master/scripts/s_stSearches.m). Here are a few examples from that file.

```
projects = st.search('projects');
VWFAsessions = st.search('sessions','project label','VWFA');
    
files = st.search('files',...
    'collection label','Anatomy Male 45-55',...
    'acquisition label','Localizer',...
    'file type','nifti');

thisProject = 'ALDIT';
[sessions,srchCmd] = st.search('session',...
    'string','BOLD_EPI',...
    'project label exact',thisProject,...
    'summary',true);

[files,srchCmd] = st.search('file',...
    'session id',sessionID,...
    'summary',true);

% Sessions that are part of the GearTest collection
sessions = st.search('session',...
    'collection label exact','GearTest',...
    'summary',true);

%% Count the number of sessions created in a recent time period
sessions = st.search('session',...
    'session after time','now-16w',...
    'summary',true);

% Structs defining the group
groups = st.search('group','all');
disp(groups)

% Projects owned by a particular group
group = 'Wandell Lab';
[projects,srchCmd] = st.search('project',...
    'group label',group,...
    'summary',true);

% Analyses within a project
analyses = st.search('analysis',...
    'project label contains','VWFA FOV',...
    'summary',true);

```





