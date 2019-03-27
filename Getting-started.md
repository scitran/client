The remainder of this wiki describes how to perform tasks using the **scitran** client methods. Tasks include

* find and search for data and metadata
* read, download or upload data and metadata
* launch jobs (Gears) and check their status
* download or upload the outputs of jobs (analyses)

This example illustrates the 'look-and-feel' of the **scitran** code.  The first example identifies a group, and then all the projects that are part of the group
```
>> st = scitran('stanfordlabs');      % Connect to 'stanfordlabs'
>> group = st.lookup('wandell');      % Lookup a group
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
In this example, 'group' is a pointer to an object in the database.  Using 'group.projects()' is a method that lists all of the projects for that group.  stPrint() is a scitran function that prints out a slot.

In a second example, you might lookup a specific project in a group that you belong to

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
The returned pointer (thisProject) has information about the project and it also has methods that let you find the sessions that are part of the project
```
>> sessions = thisProject.sessions();
>> numel(sessions)

ans =

    31
```
