
To perform a search, you must first obtain [authorization](https://github.com/scitran/client/wiki/Authorization).  

    st = scitran('action','create','instance','scitran');

The st.search() command specifies your search through a series of parameters.  The first parameter is a required string that indicates what type of object you would like to have returned.  For example, siuppose you are searching for a file.  Then you would specify

    st.search('files');

The next set of parameters are all in parameter/val format, and they are optional.  Suppose you would like to return the files in a collection name 'GearTest'.

    % These files match the following properties
    files = st.search('files','collection label','VWFA','file type','nifti','file measurement','Anatomy_t1w');

To run the search

    files = st.search(srch);

The variable 'files' is a cell array of Matlab structures;  each contains the database information of a file that matches the search criteria.  You can retrieve one of these files with the stGet() command

    st.get(files{1})

You can direct the output to a particular destination using

    st.get(files{1},'destination',localFileName)

There are many (many, many) types of searches, and you can see examples on the [search examples page](https://github.com/scitran/client/wiki/Search-examples).  Searches return Matlab cell arrays of sessions, projects, collections, acquisitions, analyses.  

Programming examples of the search syntax are in the script
[s_stSearches.m](https://github.com/scitran/client/blob/master/matlab/scripts/s_stSearches.m)

#### Gear-head Notes
Scitran stores files using complex names designed for efficiency. Specifically, the file names reflect a complex computation based on their content.  Thus, when the same file is uploaded to the database, it has the same filename (content addressable data). This offers some striking efficiencies (no need to duplicate files).

Scitran's [MongoDB database](https://www.mongodb.org/) describes information about these files, and this is addressed through the MongoDB API.  

When humans want to interact with the files, we need understandable filenames and paths.  The scitran client uses [elastic search](http://joelabrahamsson.com/elasticsearch-101/) to find files and other database objects (sessions, projects, acquisitions, collections, analyses).  Hence, in this system we do not find files by leafing through directories and looking for files - the directories and filenames are not human-readable.  Rather we search for files.

There are other ways to humanize interactions with the files in a database. In an earlier implementation of the database, Bob Dougherty used the [Fuse filesystem](https://en.wikipedia.org/wiki/Filesystem_in_Userspace), a particularly useful tool for writing virtual file systems.  Historically, the method has [security issues](https://github.com/libfuse/libfuse/issues/15), and moreover we believe that search is central to our mission.  So, we converted to the elastic search approach.

