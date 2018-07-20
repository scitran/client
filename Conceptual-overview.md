This page describes general principles that are part of the **scitran** methods and the **Flywheel SDK**.  It is intentionally short and thus incomplete; but we think that it is important that you have this conceptual overview before you begin programming with these tools.

The Flywheel environment is designed to support both data management and reproducible computations.  We say a little bit about each on this page.  We will add links to more detailed help and examples over time.  This page will stay short.

## Flywheel data management

### Data and metadata
Flywheel uses a database to manage information and computations.  A database is part of most modern computer architectures, but you don't normally think about it. For example, on a Mac you ask for the 'Info' on about a file and you are provided with data (e.g., file size, date of access). The file is the **data**, and the information about the file is the **metadata**. 

For scientific data management the metadata will include critical information (TR, TE, voxel size, number of diffusion directions, ...). The scitran methods for [data management](data-management) include utilities for searching, reading and editing both data and metadata.

### Containers
The Flywheel system is built to organize data, and it uses a directory-tree organization that is very common in all computer systems.  First, Flywheel identifies you and your group membership; you can see all the data that you have permission to access. The organization of the data, and the names of the terms, are designed to match a typical neuroimaging experiment.  The data organization starts with a Project container.  Each project contains multiple Sessions. Each Session contains multiple Acquisitions, and these contain files.  

A difference between computers and the database concerns the flexibility of the container structures; in a general computer you can have many layers of directories and you can name them freely.  The database system is structured:  We also expect that there will be an organization of Project, Session, and Acquisition ('Containers') and then the files. This regularity makes it possible to search very quickly, and it offers other benefits.

For example, there is metadata attached to each of the containers and the files. The metadata takes the form of notes, tags, or files that describe important information about the containers and files.  

Also, to find a file you generally have to know its container. Just as you locate yourself on a computer system with a directory tree, you locate yourself in the database by a sequence of containers (Project -> Session -> Acquisition -> File). A significant difference is that we expect there to be important metadata attached to containers and files. While in most computer systems users think almost entirely about the files, in database systems users often think about the metadata, too.

The scitran methods are organized the actions that you apply to containers and files.  The methods are named using the structure you want to access followed by the action you want to perform.  For example, scitran.containerDownload, or scitran.fileUpload.  The arguments to the function specify the details, such as the container type, the file name, and so forth.

### Notes, tags and attachments
Like the Mac operating system, we use the word Information (or Info) to refer to metadata.  There are many methods to read and modify the Info fields in Flywheel system.  These information fields are particularly critical for scientific data management because the data files themselves do not usually contain all the information needed to describe the experimental measurements.

For example, the widely used NIfTI format does not include much information about the MR 

## Flywheel computations
We talk about analyses and the toolbox class.

The [analysis methods](Toolboxes) support reproducible computation, such as interactions with github repositories.

We describe jobs.