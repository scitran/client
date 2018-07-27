* [Creating a **scitran** object](Connecting-and-Authentication) to securely communicate with a Flywheel system 
* [**scitran** data management methods](data-management) to search, download, upload and edit data and metadata.

***

### Data and metadata
Flywheel uses a database to manage information.  A database is part of most modern computer architectures. For example, when you ask for the 'Info' about a file on a Mac, you are provided with file metadata (e.g., file size, date of access). The file itself is the **data**, and the information about the file is the **metadata**. 

In MRI metadata includes critical scientific information (TR, TE, voxel size, number of diffusion directions, ...). Such information can be included within the data file, for example the DICOM format has an extensive header. But the widely used NIfTI format does not include much information about the MR parameters. When Flywheel converts a DICOM file to a NIfTI file, it stores this information into Flywheel metadata associated with the NIfTI file.

### Containers - Projects, Sessions and Acquisitions
The Flywheel database organizes information using a hierarchy that matches a typical scientific (neuroimaging) experiment. The data is part of a Project; each project contains multiple Sessions; each session contains multiple Acquisitions; each acquisition contains multiple **data files**.  All of these objects have various types of metadata.

The Project, Session and Acquisitions are called containers.  There is one additional type of data container, the **Collection**, that we describe at the end of this page.

The database hierarchy has less flexibility than an operating systems' directory tree. The operating system can have many layers of directories that can be named freely. The power and speed of a database for searching system relies on having a more disciplined structure:  The hierarchy of the user's Group, Project, Session, and Acquisition ('Containers') and files, coupled with specific formats for the metadata, is enforced. The benefit is that you can rapidly search, categorize and compute using the data and metadata.

There is one important conceptual difference to remember as well: When using a computer we typically focus on the files and directories. When using database systems, the metadata has a very prominent role. You will find critical experimental information that is indexed and searchable in the metadata. All Flywheel Containers and Files have metadata. 

### Methods and data

**Scitran** methods are organized the actions that apply to containers, data files, and metadata. The naming convention we use is to specify the **type of object** followed by an **action**.  For example, suppose you create a scitran object, 

    st = scitran('stanfordlabs');

The object has many methods like these.
```
st.containerDownload - downloading one of the several container types
st.containerCreate - Create a container on the remote site
st.fileDownload - downloads a data file
st.fileDelete -  delete a file
```
Use tab-completion (e.g., st.file<Tab>) to see the current list. The arguments to the method specify the container type and other necessary parameters. 

### Metadata - Notes, tags and attachments

**scitran** methods use the term Info to refer to actions on the metadata. There are many methods to read and modify the Flywheel Info fields.

    st.containerInfoGet - Read the metadata from a container

Certain types of **metadata** are given a special status.  These are **notes, tags, and attachments**.  They are all metadata, but it dawned on us that people use this system, and people like having meaningful names for certain types of information. 

More details about the [Flywheel data model are here](Flywheel-data-model)

### A virtual project:  Collections

Data management simplifies the task of reusing data.  In a typical computer system, reusing the data typically means copying many files into a new directory tree.  In a database, however, we can easily create a virtual experiment just by adding new fields into the database.  The data stay in their position, but we see the virtual experiment by looking up all the files that are in the database field.

A collection is an entry, like a project, in the database.  The contents of a collection are sessions, acquisitions, and files that are present in the database.  In this way, a Collection looks just like a Project.  The data and metadata in the Collection can be drawn from anywhere in the database.  A Collection is a virtual project based on reusing data.  **Scitran** has many methods to interact with Collections

[Flywheel collections manual](https://docs.flywheel.io/display/EM/Using+Collections)