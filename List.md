* [List examples](List-examples)

***
When you know the general structure of the data in a project, and you would like to find a specific container or the files in a container, you can use the scitran.list method.  This method is similar to the Unix 'ls' command, or the 'dir' command.

The scitran **list** method is useful when you know the containers (project, session, acquisition or collection), and you want to list the container content. The list command returns a cell array, and each cell has the type of the object that you are listing.  For example, listing the sessions in a project returns a cell array of objects in the class _flywheel.model.Session_.