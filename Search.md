Scitran stores files using complex names designed for efficiency.  The files are named by their content (content addressable data), which offers some striking efficiencies. Scitran's [MongoDB database](https://www.mongodb.org/) describes information about these files, and this is addressed through the MongoDB API.

But when humans want to interact with the files, we need clearer filenames and procedures.  The scitran client uses [elastic search](http://joelabrahamsson.com/elasticsearch-101/) to provide a simple clear way to access files and other database objects (sessions, projects, acquisitions, collections, analyses).

Because the database is secure, you must first obtain [authorization](https://github.com/scitran/client/wiki/Authorization).  Typically, we store the url and token in a structure, such as

    st = scitran('action','create','instance','scitran');

Then, create a Matlab structure to identify do the search. Perhaps the simplest and most important example is to identify files for downloading.  We do this by setting up a structure, 'b', with a slot that indicates we are looking for files.

    clear b
    srch.path = 'files';                         % Looking for files

Then we identify the file properties.  

    % These files match the following properties
    srch.collections.match.label  = 'GearTest';   % In the collection named GearTest
    srch.acquisitions.match.label = 'T1w';        % Part of an acquisition named T1w (T1-weighted)
    srch.files.match.type         = 'nifti';      % The file type is nifti

Finally, you are ready to run the search

    % Run the search and get information about files that match the criteria
    files = st.search(srch);

The variable 'files' is a cell array of Matlab structures;  each contains the database properties of a file that matches your criterion.  You can retrieve one of these files with the stGet() command

    st.get(files{1},s.token,'destination',localFileName)

There are many (many, many) types of searches possible.  We explain the general syntax and provide examples in *s_stSearches.m*.

####Note
There are several ways to humanize interactions with the files.  For example, in one implementation of the database we used the [Fuse filesystem](https://en.wikipedia.org/wiki/Filesystem_in_Userspace), a particularly useful tool for writing virtual file systems.  Historically, the method has [security issues](https://github.com/libfuse/libfuse/issues/15).

