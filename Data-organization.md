The **scitran** [data management methods](data-management) search, download, upload and edit all kinds of information about your data.  This section describes the data organization.

### Data and metadata
Flywheel uses a database to manage information.  A database is part of most modern computer architectures. For example, on a Mac you ask for the 'Info' on about a file and you are provided with data (e.g., file size, date of access). The file is the **data**, and the information about the file is the **metadata**. 

The metadata include critical scientific information (TR, TE, voxel size, number of diffusion directions, ...). Such information is not always part of the data file.  For example, the widely used NIfTI format does not include much information about the MR parameters (the DICOM file includes much more). When Flywheel converts a DICOM file to a NIfTI file, it stores the critical information into the metadata of the data file.  

### Containers
The Flywheel database uses a simple hierarchy to organize the data.  The hierarchy is designed to match a typical neuroimaging experiment. The top level is a Project.  Each project contains multiple Sessions. Each Session contains multiple Acquisitions, and these contain **data files**.  The Project, Session and Acquisitions are called containers.

A difference between computers and the database concerns the flexibility of the containers; a general operating system can have many layers of directories and you can name them freely.  Much of the power and speed of a database system comes from its structure:  The Project, Session, and Acquisition ('Containers') and the files are always present.

There containers and the files can all have metadata; this takes the form of **notes, tags, or attachments** that describe important information the experiment. While in most computer systems users think almost entirely about the files, in database systems there is always important metadata connected to the containers and files. 

The scitran methods are organized the actions that apply to containers, data files, and metadata. The naming convention we use is to specify the type of object followed by an action.  For example, suppose you create a scitran object, 

    st = scitran('stanfordlabs');

The  **st.containerDownload** is a method for downloading one of the several container types.  The method **st.fileDownload** downloads a file. Notice that we distinguish between containers and files (directories and files).  To see all the methods that apply to containers, type st.container<TAB>. The arguments to the method specify critical details, such as the container type, the file name, and so forth.

### Notes, tags and attachments
We use the word Information (or Info) to refer to actions on the metadata.  There are many methods to read and modify the Info fields in Flywheel system.  These information fields are particularly critical for scientific data management because the data files themselves do not usually contain all the information needed to describe the experimental measurements.


More details about the [Flywheel data model is here](Flywheel-data-model)
