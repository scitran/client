Most of this wiki describes how to perform tasks using the **scitran** client methods. Tasks include

* search for data and metadata
* download and upload data and metadata
* download-analyze-upload loop
* launch jobs (Gears), check their status, and download their outputs

This example illustrates the 'look-and-feel' of the **scitran** code.  The first example identifies a group, and then all the projects that are part of the group
```
>> st = scitran('stanfordlabs');      % Connect to 'stanfordlabs'
>> group = st.lookup('wandell');      % Lookup a group based on its ID
>> projects = group.projects();       % Find the projects associated with this group
>> stPrint(projects,'label');         % Print out the project labels ...

Entry: label.
-----------------------------
	1 - BCBL_ILLITERATES 
	2 - Brain Beats 
	3 - CoRR 
	4 - EJ Apricot 
	5 - Graphics assets 
	6 - HCP 
	7 - HCP_preproc 
        ....
```

In this second example, we lookup a specific project in a group
```
>> thisProject = st.lookup('wandell/HCP')    % This is the HCP project in the group 'wandell'

thisProject = 

  ResolverProjectNode with properties:

         public: []
          label: 'HCP'
           info: [1×1 flywheel.model.CommonInfo]
    description: ' ... .... '
          group: 'wandell'
             id: '57745645ce3b5900238d466c'
        parents: [1×1 flywheel.model.ContainerParents]
     infoExists: []
        created: 29-Jun-2016 23:14:13
       modified: 09-Nov-2018 05:30:55
      templates: []
    permissions: {16×1 cell}
          files: {3×1 cell}
          notes: []
           tags: []
       analyses: []

```
The returned object (thisProject) has information about the project. It also has methods to find the sessions that are part of the project
```
>> sessions = thisProject.sessions();
>> numel(sessions)

ans =

    31
```
Or list the subjects in a project
```
>> subjects = thisProject.subjects();
>> numel(subjects)

ans =

    30
```