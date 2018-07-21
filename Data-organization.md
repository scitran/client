* The **scitran** [data management methods](data-management) search, download, upload and edit your data and metadata.
* Matlab interacts with the Flywheel system through a [connecting scitran object](Connection-and-Authentication), ```st = scitran('yourSiteName');```

***

### Data and metadata
Flywheel uses a database to manage information.  A database is part of most modern computer architectures. For example, on a Mac you ask for the 'Info' on about a file and you are provided with data (e.g., file size, date of access). The file is the **data**, and the information about the file is the **metadata**. 

The metadata include critical scientific information (TR, TE, voxel size, number of diffusion directions, ...). Such information is not always part of the data file.  For example, the widely used NIfTI format does not include much information about the MR parameters (the DICOM file includes much more). When Flywheel converts a DICOM file to a NIfTI file, it stores the critical information into the metadata of the NIfTI file.  

### Containers - Projects, Sessions and Acquisitions
The Flywheel database uses a simple three-level hierarchy to organize the data.  The hierarchy is designed to match a typical neuroimaging experiment. The top level is a Project; each project contains multiple Sessions; each session contains multiple Acquisitions; each acquisition contains multiple **data files**.  

The Project, Session and Acquisitions are called containers.  The files are called files.

A difference between computers and the database concerns the flexibility of the containers; a general operating system can have many layers of directories and you can name them freely.  Much of the power and speed of a database system comes from its structure:  The Project, Session, and Acquisition ('Containers') and the files are always present.

Containers and files can all have metadata.  While in most computer systems users think almost entirely about the files, in database systems there is always important metadata connected to the containers and files. 

The scitran methods are organized the actions that apply to containers, data files, and metadata. The naming convention we use is to specify the type of object followed by an action.  For example, suppose you create a scitran object, 

    st = scitran('stanfordlabs');

There are many methods like these.
```
st.containerDownload - downloading one of the several container types
st.containerCreate - Create a container on the remote site
st.fileDownload - downloads a data file
st.fileDelete -  delete a file
```
Notice that we distinguish between containers, files and info.  Use tab-completion (e.g., st.file<Tab>) to see the current list. The arguments to the method specify the container type and other necessary parameters. 

### Metadata - Notes, tags and attachments

We use the word Information (or Info) to refer to actions on the metadata. There are many methods to read and modify the Info fields in Flywheel system.  These information fields are particularly critical for scientific data management because the data files themselves do not usually contain all the information needed to describe the experimental measurements.

    st.containerInfoGet - Read the metadata from a container

Certain types of container and file **metadata** are given a special status.  We call these **notes, tags, and attachments**.  Honestly, they are just metadata.  But it dawned on us that people use this system, and sometimes they like having meaningful names for certainly classes of information. 

More details about the [Flywheel data model are here](Flywheel-data-model)
