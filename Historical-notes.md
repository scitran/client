#### Technical notes
Scitran stores files using complex names designed for efficiency. Specifically, the file names reflect a complex computation based on their content.  Thus, when the same file is uploaded to the database, it has the same filename (content addressable data). This offers some striking efficiencies (no need to duplicate files).

Scitran's [MongoDB database](https://www.mongodb.org/) describes information about these files, and this is addressed through the MongoDB API.  

When humans want to interact with the files, we need understandable filenames and paths.  The scitran client uses [elastic search](http://joelabrahamsson.com/elasticsearch-101/) to find files and other database objects (sessions, projects, acquisitions, collections, analyses).  Hence, in this system we do not find files by leafing through directories and looking for files - the directories and filenames are not human-readable.  Rather we search for files.

There are other ways to humanize interactions with the files in a database. In an earlier implementation of the database, Bob Dougherty used the [Fuse filesystem](https://en.wikipedia.org/wiki/Filesystem_in_Userspace), a particularly useful tool for writing virtual file systems.  Historically, the method has [security issues](https://github.com/libfuse/libfuse/issues/15), and moreover we believe that search is central to our mission.  So, we converted to the elastic search approach.
