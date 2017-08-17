# Brain Imaging Data Structure (BIDS)

## Planning

We have a Matlab class for BIDS. It walks through any of the BIDS-example directories and finds all the files, storing the directory tree.

We have an example of using the BIDS object and uploading all the files to a Flywheel project.

We have an example of downloading a project that was uploaded as BIDS, and writing it back out as a BIDS directory.  (Round trip).

We have one brief validate method, and others are in the works.

## The BIDS class

Methods include - bids (constructor), listSubjectFolders, listDataFiles, listMetaDataFiles, validate, countSessions

Directory names are stored relative to the main directory.

### Variables

* Project name
* Number of subjects (participants.tsv file)
* Stimulus folder (contents are arbitrary?)
* Folder for every subject
* Number of sessions per subject
* Data types in each session
* Number of runs of a given data type in a session
* Metadata files (json and tsv)

## Usage in scripts

s_bidsPut

v_stProjectDownload


