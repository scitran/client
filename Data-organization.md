* See general notes about data and metadata at the end

***

### Containers - Projects, Sessions and Acquisitions
The Flywheel database organizes information using a hierarchy that matches a typical neuroimaging project. The top level of the hierarchy is a Project; each project contains multiple Sessions; each session contains multiple Acquisitions; each acquisition contains multiple **data files**.

The Project, Session and Acquisitions are called containers.  ** scitran ** has methods to work with containers or files.  These can be found in the @scitran folder, or once you have created a scitran object use <TAB>-completion

    scitran.container<TAB>
    scitran.file<TAB>

One additional type of data container, the **Collection**, is described later on this page. Other objects (Gears, Jobs, and Analyses) that are described in the [Computational organization section](Computational-organization).

### Notes, tags and attachments

**scitran** methods use the term Info to refer to actions on the metadata. There are many methods to read and modify the Flywheel Info fields.

    st.infoGet - Read metadata from a container or file
    st.infoSet - Write metadata on a container or file

Info is organized into various types: **notes, tags, and attachments**.  They are all metadata, but it is useful to have distinguish between certain types of information. 

More details about the [Flywheel data model are here](Flywheel-data-model)

### Virtual projects:  Collections

Flywheel lets you select data for reuse by creating a Collection. The contents of a collection are sessions, acquisitions, and files that you choose from the database.  In the user interface, a Collection looks like a Project.  We think of a Collection as a virtual project based on reusing data.  

**Scitran** has methods to create and delete Collections.  These can be found using

    scitran.collection<TAB>

### General comments about Data and Info (metadata)
#### Flywheel uses a database to manage information.  
A database is part of most modern computer architectures. For example, when you ask for the 'Info' about a file on a Mac, you are provided with file metadata (e.g., file size, date of access). The file itself is the **data**, and the information about the file is the **metadata**. Like the Mac, Flywheel calls the metadata in its system 'Info' or 'Information'.

#### Metadata
MRI Info includes critical scientific information (TR, TE, voxel size, diffusion directions, ...). This information can be included within a data file, for example the DICOM format includes this information in its header. The widely used NIfTI format does not include as much information in its default header. When Flywheel converts a DICOM file to a NIfTI file, it stores the MRI Info into Flywheel metadata attached to the NIfTI file. 

In typical computer usage, we focus on directories and files. When using database systems, the Info (metadata) has a very prominent role. You can find the INFO in the web-browser interface, and you can download it with the SDK.

#### The database hierarchy
The speed of a database search relies on having a disciplined data organization.  The Flywheel hierarchy comprises the user's Group, Project, Session, Acquisition and Files. The benefit of enforcing the hierarchy is that you can rapidly search, categorize and compute using the data and Info.

#### Data reuse
To reuse data, users often copy files into a new directory tree. Using the Flywheel database there is no need to copy. We can reuse the data by copying fields from the database. Flywheel creates a **virtual project* by creating a database entry that contains pointers to existing files. To the user, this appears to be a new project.  Flywheel calls these 'Collections'.  Maybe they should be called 'Virtual Projects.'
