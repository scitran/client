### Data Containers - Projects, Sessions and Acquisitions
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
