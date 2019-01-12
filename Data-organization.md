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
Flywheel uses a database to manage information.  A database is part of most modern computer architectures. For example, when you ask for the 'Info' about a file on a Mac, you are provided with file metadata (e.g., file size, date of access). The file itself is the **data**, and the information about the file is the **metadata**. Like the Mac, Flywheel calls the metadata in its system 'Info' or 'Information'.

MRI Info often includes critical scientific information (TR, TE, voxel size, number of diffusion directions, ...). Such information can be included within the data file, for example the DICOM format includes this information in an extensive header. The widely used NIfTI format does not, by default, include much information about the MR parameters. When Flywheel converts a DICOM file to a NIfTI file, it stores this information into Flywheel metadata associated with the NIfTI file.

A database hierarchy has less flexibility than an operating systems' directory tree. The speed of a database search relies on having a more disciplined structure:  The hierarchy of the user's Group, Project, Session, and Acquisition ('Containers') and Files, coupled with specific formats for the metadata. The operating system can have many layers of directories that are organized arbitrarily. The benefit of the hierarchy is that you can rapidly search, categorize and compute using the data and Info.

There is one important conceptual difference to remember as well: When using a computer we typically focus on the files and directories. When using database systems, the Info (metadata) has a very prominent role. You will find critical experimental information that is indexed and searchable in the Info fields. All Flywheel Containers and Files can have Info. 

Finally, users often reuse data copying files into a new directory tree.  In a database, however, we can reorganize data by selecting fields from the database. Using this method, we can present the user with a new **virtual project* by just creating a database entry that looks like a new project, but contains pointers to existing files.
