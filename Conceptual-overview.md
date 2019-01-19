The **scitran** client makes a connection between Matlab and a Flywheel instance.  Through that connection you can search for data, read data, read metadata, start jobs that create analyses, and download the analyses. This wiki describes the software methods for such tasks.  As a very simple example, this code makes the connection to the 'stanfordlabs' Flywheel instance, lists the projects owned by 'wandell', and prints the metadata about one project.
```
>> st = scitran('stanfordlabs');                 % Make the connection
>> projects = st.list('project','wandell')       % List the projects
>> projects{2}                                   % Print out the project details

ans = 

  Project with properties:

         public: 0
          label: 'Brain Beats'
           info: [1×1 flywheel.model.CommonInfo]
    description: '#### Bakground↵Starting in 2015 we collected fast fMRI scans with simultaneous multislice acquisitions to measure signals related to heartbeats (and maybe respiration).↵↵In 2015 we acquired scans in the following slice order: `[(1:2:round(nslices)) (2:2:round(nslices))]`, now added in a custom field `mux_slice_order`.↵↵↵#### Future Directions↵In 2018 we will be experimenting with different variations of this slice sequence.'
          group: 'wandell'
             id: '597b57d097276d001787e839'
        parents: [1×1 flywheel.model.ContainerParents]
     infoExists: 0
        created: 28-Jul-2017 15:27:12
       modified: 09-Nov-2018 05:41:21
      templates: []
    permissions: {[1×1 flywheel.model.Permission]}
          files: []
          notes: []
           tags: []
       analyses: []

>> 
```
Understanding the principles of the [Data organization](Data-organization) and [Computational organization](Computational-organization) can be important to effectively use **scitran**.  The comments below describe these principles.

### Data

#### Databases
A database is part of most modern computer architectures. For example, when you ask for the 'Info' about a file on a Mac, you are provided with file metadata (e.g., file size, date of access). The file itself is the **data**, and the information about the file is the **metadata**. Like the Mac, Flywheel calls the metadata in its system 'Info' or 'Information'.

#### Metadata
MRI Info includes critical scientific information (TR, TE, voxel size, diffusion directions, ...). This information can be included within a data file, for example the DICOM format includes this information in its header. The widely used NIfTI format does not include as much information in its default header. When Flywheel converts a DICOM file to a NIfTI file, it stores the MRI Info into Flywheel metadata attached to the NIfTI file. 

In typical computer usage, we focus on directories and files. When using database systems, the Info (metadata) has a very prominent role. You can find the INFO in the web-browser interface, and you can download it with the SDK.

#### Data hierarchy
The speed of a database search relies on having a disciplined data organization.  The Flywheel hierarchy comprises the user's Group, Project, Session, Acquisition and Files. The benefit of enforcing the hierarchy is that you can rapidly search, categorize and compute using the data and Info.

#### Data reuse
To reuse data, users often copy files into a new directory tree. Using the Flywheel database there is no need to copy. We can reuse the data by copying fields from the database. Flywheel creates a *virtual project* by creating a database entry that contains pointers to existing files. To the user, this appears to be a new project.  Flywheel calls these 'Collections'.  Maybe they should be called 'Virtual Projects.'

### Computations

#### Sharing software
Modern software is very complex to create and maintain. Compiling software - yes, even from freely available code on github! - can be daunting. A computational management system helps all users by providing the programs in a format that everyone can use.  Given that data are stored in the system, the shared computational methods can be applied to everyone's data.

#### Platform-independent computing
But what format should the computations be stored in? Users use many different operating systems (PC, Mac, Linux, each with different variants) and code is compiled for a particular system. Small virtual machines, also called Containers, are a solution.  If we compile the code once within the virtual machine, we can install the virtual machine and then run the code on many different platforms.  Docker Containers are small virtual machine that can be installed and run on nearly all platforms. Hence, your software can be run on Cloud or Local systems.

#### Cloud-scale elastic computing
When running on the cloud, it is possible to expand and shrink the compute resources available for your project on demand. Flywheel has a computational management system that runs on the Google Cloud Platform.  More resources are added when users run more Jobs.  These resources are released when demand is low.  Cloud-scaling is a cost-effective approach if your computing happens in cyclical bursts.

#### Reproducible computing
To be reproducible, we must know exactly what computations were run.  Hence, a reproducible system must track which Containers were run, what the inputs were, and where the outputs were stored.  If this information is stored in the system,  you or a colleague can re-run precisely the same computation using either the same or different data.

#### Software development
To develop new software based on new ideas, we need to writing new programs. A software development kit (SDK) is an important resource that lets people test their ideas using the programming environment.  Such a kit should enable people to perform all of the functions that are embedded in the web-interface, and then build from there.

