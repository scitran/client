# Brain Imaging Data Structure (BIDS)

## Planning

Write a Matlab BIDS validator

* First Local - check that the local data have file names and directory tree compliant with BIDS
* Second Local - check that the content of the JSON and NII files are consistent and compliant
* Third Remote - Check that the session and acquisition names are compliant with BIDS
* Fourth Remote - Check that the files in the sessions and acquisition are BIDS compliant

We will write a BIDS class (@bids) that contains the information in the directory tree (dirwalk or dirPlus can get us the directories and files.  These are on the FileExchange Central at Mathworks).  

We will write validation methods.

* @bids.validateDirectoryTree(session)
* @bids.validateDirectoryFiles(directory)
* @bids.validateFileContents(dataType)

## The BIDS class

### Variables

* Project name
* Number of subjects (participants.tsv file)
* Stimulus folder (contents are arbitrary?)
* Folder for every subject
* Number of sessions per subject
* Data types in each session
* Number of runs of a given data type in a session
* Metadata files (json and tsv)
* 


