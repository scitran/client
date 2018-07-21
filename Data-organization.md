* The **scitran** [data management methods](data-management) search, download, upload and edit your data and metadata.
* Matlab interacts with the Flywheel system through a [connecting scitran object](Connecting-and-Authentication), ```st = scitran('yourSiteName');```

***

### Data and metadata
Flywheel uses a database to manage information.  A database is part of most modern computer architectures. For example, on a Mac you ask for the 'Info' on about a file and you are provided with data (e.g., file size, date of access). The file is the **data**, and the information about the file is the **metadata**. 

The metadata include critical scientific information (TR, TE, voxel size, number of diffusion directions, ...). Such information is not always part of the data file.  For example, the widely used NIfTI format does not include much information about the MR parameters (the DICOM file includes much more). When Flywheel converts a DICOM file to a NIfTI file, it stores the critical information into the metadata of the NIfTI file.  

### Containers - Projects, Sessions and Acquisitions
The Flywheel database organizes the data using a hierarchy that is matched to a typical scientific (neuroimaging) experiment. The user has access to a specific set of Projects; each project contains multiple Sessions; each session contains multiple Acquisitions; each acquisition contains multiple **data files**.  

The Project, Session and Acquisitions are called containers.  They are analogous to directories. The files are called files.  There is one additional type of data container, the **Collection**, that we describe at the end of this page.

Computer operating systems and databases differ in flexibility; an operating system can have many layers of directories and you can name them freely.  The power and speed of a database system relies on having a more disciplined structure:  The hierarchy of a Group, Project, Session, and Acquisition ('Containers') and files is always present.

There is one more difference: In most computer systems users think about the file contents. In database systems the metadata connected to the containers and files is very important, too. All Flywheel Containers and Files have metadata. 

### Methods and data

**Scitran** methods are organized the actions that apply to containers, data files, and metadata. The naming convention we use is to specify the **type of object** followed by an **action**.  For example, suppose you create a scitran object, 

    st = scitran('stanfordlabs');

There are many methods like these.
```
st.containerDownload - downloading one of the several container types
st.containerCreate - Create a container on the remote site
st.fileDownload - downloads a data file
st.fileDelete -  delete a file
```
Notice that we distinguish between containers and files.  Use tab-completion (e.g., st.file<Tab>) to see the current list. The arguments to the method specify the container type and other necessary parameters. 

### Metadata - Notes, tags and attachments

We use the word Information (or Info) to refer to actions on the metadata. There are many methods to read and modify the Flywheel Info fields.  These fields are particularly critical for scientific data management because the data files themselves do not usually contain all the information needed to describe the experimental measurements.

    st.containerInfoGet - Read the metadata from a container

Certain types of container and file **metadata** are given a special status.  We call these **notes, tags, and attachments**.  Honestly, they are just metadata.  But it dawned on us that people use this system, and sometimes they like having meaningful names for certainly classes of information. 

More details about the [Flywheel data model are here](Flywheel-data-model)

### A special container type: Collections

Virtual experiments described

Pointers, reuse, database

