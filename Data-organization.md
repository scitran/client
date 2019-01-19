### Data Containers - Projects, Sessions and Acquisitions
The Flywheel database hierarchy matches a typical neuroimaging project. The top level is a Project; each project contains multiple Sessions; each session contains multiple Acquisitions; each acquisition contains multiple Files.

The Project, Session and Acquisitions are called data containers. Many **scitran** methods work with containers or files.  Once you create a scitran object use <TAB>-completion to see the methods

    scitran.container<TAB> - Shows all the basic Data Container methods
    scitran.file<TAB>      - Shows all the basic File methods 
    scitran.<TAB>          - Shows all the methods

One additional data container type, the **Collection**, is described later on this page. Other objects (Analyses, Gears, and Jobs) are described in the [Computational organization section](Computational-organization).

### Notes, tags and attachments

We use the term **info** to refer the metadata. There are methods to read and modify the Flywheel Info fields.

    st.infoGet - Read metadata from a container or file
    st.infoSet - Write metadata on a container or file

Info is organized into various types: **notes, tags, and attachments**.  These are all metadata, but it is useful to have distinguish between certain types of information. You can set notes, tags and attachments with the info* methods.

### Virtual projects:  Collections
To reuse data we create a new data container, the **Collection**. A Collection includes a subset of the sessions, acquisitions that the user selects from the database.  In the user interface, a Collection looks like a Project.  A Collection as a virtual project based on data reuse.  

**Scitran** has methods to create and delete Collections.  These can be found using

    scitran.collection<TAB>

### References

* More details about the [Flywheel data model are here](Flywheel-data-model)
