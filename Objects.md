Starting with **version 4.4.5** the SDK containers are **objects**. These **SDK objects** include 

1. metadata about a Flywheel object, and
2. methods that can be executed using the container metadata. 

For example, you can 

* Retrieving the container's contents
* Retrieve specific content using 'find'
* Download or upload files from the container

There are many SDK Object methods, and we provide a list of things you might do elsewhere.  As a simple example, here is a way to find the files attached to a project.
```
project = st.lookup('adni/ADNI: T1');
adniProjectFiles = project.files;
>> stPrint(adniProjectFiles,'name')

Entry: name.
-----------------------------
	1 - ADNI_GeneralProceduresManual.pdf 
	2 - db_accesslog.csv 
```