
We added some utility parameters that are for 'quality of life.'

### Utility parameters

* **'summary'**  - A logical that indicates whether to print the number of found objects ('summary',true)
* **'all_data'** - Run the search across the entire database ('all_data',true); 
* **'limit'**    - Limit number of returned cells, st.search('file','limit',17,'file name','foo); (default 10,000)

N.B. Even if 'all_data' is true, you cannot query or download objects unless you have permission

### Search string

You can add a parameter 'string', which does a free form search within the other parameter constraints. For example, this is a search for acquisitions that have the string 'BOLD_EPI' somewhere in a label, name, or note.
```
[acquisitions,srchCmd] = st.search('acquisition',...
    'string','BOLD_EPI',...
    'project label exact','ALDIT', ...
    'summary',true);
```
### Groups

It is possible to search for information about the groups using the database.  This information includes their project names and users. For example, to list all of groups use

    st.search('group','all')

Other 'group' search parameters are 
```
st.search('group','all names');       % All group names
st.search('group','name',groupName);  % Details about a particular group
st.search('group','users',groupName); % Users from a group
st.search('group','all labels');      % Groups appear to have both labels and names
```
### Partial and exact matches

When searching for an object based on its label (or name), you can specify an exact match or a partial match. For example, on the vistalab site we have a project with the label 'VWFA' and several other projects that include 'VWFA' in the label.  
A search based on 'contains' is case insensitive; 'exact' is case-sensitive.

When we search for a project label exact 'VWFA'
```
>> projects = st.search('project',...
    'summary',true,...
    'project label exact','VWFA');
Found 1 (project)
```

It is possible to find all the projects that contain the string 'VWFA' as well.

```
>> projects = st.search('project',...
    'summary',true,...
    'project label contains','vwfa');
Found 3 (project)

>> for ii=1:length(projects), disp(projects{ii}.project.label); end
VWFA FOV
VWFA
VWFA FOV Hebrew
>> 
```

### Labels and names

Most objects are described by a **label**.  There is one exception, however.  When we search for files we search on the **name**, not the **label**. The exact vs. contains options are used for the **label** describing session, analysis, acquisition, collection, and the file **name**.
