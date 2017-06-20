This page contains more detailed descriptions of the search parameters. To perform a search, first create a scitran Matlab object that is authorized to interact with your database (see [Authorization](Authorization)).  Then run

    st = scitran('vistalab');

You can search for a variety of different database objects.  The search returns a cell array of the database objects that match your query. Here is a list of objects you can search for.

    objects = {'files','acquisitions','sessions','projects','collections',...
               'analyses','subjects','notes','analyses in collection','files in collection'};

The general search syntax is

    objects = st.search('<objectTypeToReturn>','Parameter',value, ...);

**objects** is a cell array of structures, each containing many different fields.  Most of the important information is in the 'source' field, say objects{1}.source.

## Labels and names

Most objects can be described by a **label**.  There is one exception, however.  When we search for files we search on the **name**, not the **label**.

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

See the searches illustrated in [s_stSearches.m](https://github.com/scitran/client/blob/master/scripts/s_stSearches.m)

Here are some additional examples.

```
projects = st.search('projects');
VWFAsessions = st.search('sessions','project label','VWFA');
    
files = st.search('files',...
    'collection label','Anatomy Male 45-55',...
    'acquisition label','Localizer',...
    'file type','nifti');
```





