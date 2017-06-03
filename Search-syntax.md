## Returned by a search

The search returns a structure that defines one of several types of scitran objects.

    objects = {'files','acquisitions','sessions','projects','collections',...
               'analyses','subjects','notes','analyses in collection','files in collection'};

The search syntax is simple

    objects = st.search('<objectTypeToReturn>','Parameter',value, ...);

The object structure contains many different contains many different fields, with most of the information in the 'source' field.

## Running a search

To perform a search, create a scitran object that is authorized to interact with your database.  Typically, this will be a command like

    st = scitran('action','create','instance','scitran');

You can do many different types of searches, such as the ones illustrated in [s_stSearches.m](https://github.com/scitran/client/blob/master/scripts/s_stSearches.m)
```
projects = st.search('projects');
VWFAsessions = st.search('sessions','project label','VWFA');
    
files = st.search('files',...
    'collection label','Anatomy Male 45-55',...
    'acquisition label','Localizer',...
    'file type','nifti');
```





