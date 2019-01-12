
### Data and metadata
Flywheel uses a database to manage information.  A database is part of most modern computer architectures. For example, when you ask for the 'Info' about a file on a Mac, you are provided with file metadata (e.g., file size, date of access). The file itself is the **data**, and the information about the file is the **metadata**. Like the Mac, Flywheel calls the metadata in its system 'Info' or 'Information'.

In MRI the Info includes critical scientific information (TR, TE, voxel size, number of diffusion directions, ...). Such information can be included within the data file, for example the DICOM format includes this information in an extensive header. The widely used NIfTI format does not, by default, include much information about the MR parameters. When Flywheel converts a DICOM file to a NIfTI file, it stores this information into Flywheel metadata associated with the NIfTI file.

### Containers - Projects, Sessions and Acquisitions
The Flywheel database organizes information using a hierarchy that matches a typical neuroimaging project. The top level of the hierarchy is a Project; each project contains multiple Sessions; each session contains multiple Acquisitions; each acquisition contains multiple **data files**.

The Project, Session and Acquisitions are called containers.  There is one additional type of data container, the **Collection**, that we describe at the end of this page.

A database hierarchy has less flexibility than an operating systems' directory tree. The speed of a database search relies on having a more disciplined structure:  The hierarchy of the user's Group, Project, Session, and Acquisition ('Containers') and Files, coupled with specific formats for the metadata. The operating system can have many layers of directories that are organized arbitrarily. The benefit of the hierarchy is that you can rapidly search, categorize and compute using the data and Info.

There is one important conceptual difference to remember as well: When using a computer we typically focus on the files and directories. When using database systems, the Info (metadata) has a very prominent role. You will find critical experimental information that is indexed and searchable in the Info fields. All Flywheel Containers and Files can have Info. 

### Methods

[**Scitran** methods](https://github.com/vistalab/scitran/wiki/scitran-methods) are organized the actions that apply to containers, data files, and info. The naming convention we use is to specify the **type of object** followed by an **action**.  For example, suppose you create a scitran object, 

    st = scitran('stanfordlabs');

The scitran object has many methods, such as
```
st.containerDownload - downloading one of the several container types
st.containerCreate - Create a container on the remote site
st.fileDownload - downloads a data file
st.fileDelete -  delete a file
```
Use tab-completion (e.g., st.file<Tab>) to see the current list.

### Notes, tags and attachments

**scitran** methods use the term Info to refer to actions on the metadata. There are many methods to read and modify the Flywheel Info fields.

    st.infoGet - Read the metadata from a container or file

Certain types of **metadata** are given a special status.  These are **notes, tags, and attachments**.  They are all metadata, but it dawned on us that people use this system, and people like having meaningful names for certain types of information. 

More details about the [Flywheel data model are here](Flywheel-data-model)

### Virtual projects:  Collections

Data management simplifies the task of reusing data.  In a typical computer system, reusing the data typically means copying many files into a new directory tree.  In a database, however, we can easily create a virtual experiment just by adding new fields into the database.  The data stay in their position, but we see the virtual experiment by looking up all the files that are in the database field.

A collection is an entry, like a project, in the database.  The contents of a collection are sessions, acquisitions, and files that are present in the database.  In this way, a Collection looks just like a Project.  The data and metadata in the Collection can be drawn from anywhere in the database.  A Collection is a virtual project based on reusing data.  **Scitran** has many methods to interact with Collections

[Flywheel collections manual](https://docs.flywheel.io/display/EM/Using+Collections)