## Data Containers (version 5.0.4 and later)
The Flywheel database hierarchy matches a neuroimaging project. The top level is the user's group;  a group typically contains multiple Projects; each project contains multiple Sessions; each session contains multiple Acquisitions; each acquisition contains multiple Files.

The SDK containers are **objects**.  Each object includes metadata about a Flywheel object, and has methods that perform useful functions. For example, you can 

* Display the container's metadata
* Update metadata
* Download or upload content from within the container (e.g., Files, Sessions, Acquisitions)

There are many [SDK Object methods](object-methods). This simple illustration uses a Project to find the files.
```
project = st.lookup('adni/ADNI: T1');
adniProjectFiles = project.files;
stPrint(adniProjectFiles,'name')

Entry: name.
-----------------------------
	1 - ADNI_GeneralProceduresManual.pdf 
	2 - db_accesslog.csv 
```



### Methods
The scitran object implements many methods, as well.  These let you perform general actions, for example

    scitran.lookup('a string')  - Returns metadata about a container
    scitran.search( ... )       - Searches the database for specific types of metadata

Or actions on specific containers and files, for example

    scitran.container<TAB> - Shows all the basic Data Container methods
    scitran.file<TAB>      - Shows all the basic File methods 
    scitran.<TAB>          - Shows all the methods

One additional data container type, the **Collection**, is described below. Other objects (Analyses, Gears, and Jobs) are described in the [Computational organization section](Computational-organization).  Most of these containers can include Files.

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

* More details about the [Flywheel SDK](https://flywheel-io.github.io/core/tags/4.4.5/matlab/getting_started.html)
