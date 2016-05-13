The database files are grouped logically into a set of basic categories that we define here.  The client search queries are structured around these categories.

* **Project** - the data from multiple sessions; a project belongs to a research *group* 
* **Session** - the collection of files acquired in an hour at the scanner.  This can include many types of data and auxiliary files
* **Acquisitions** - groups of related files during a session.  An example might be a raw (spectra) file and the dicom files produced from it and the nifti file assembled from the dicoms.  Another example is a diffusion data set in a nifti file along with the bvec and bval data.  Or fMRI data in dicom files, the nifti file, and associated physiological data.  Typically the files in a collection all result from the single push of a 'Scan' button.
* **Files** - single files, such as a nifti file, or a zip file with many dicom files

The notion of a collection or 'virtual experiment' is fundamental to the scitran approach.  The idea is that one can use search to create a new collection that you treat as a new experiment.  This enables the user to re-use data from multiple projects and do new analyses.  Through the magic of modern software, Scitran builds collections without duplicating the data.

* **Collection** - collections are groups of acquisitions or sessions.  Collections act as 'virtual experiments' in which the data collected at different projects, or by different groups, are combined and analyzed. 

To help with 
* **Analyses** - sets of files, within a collection or session, that have been analyzed using a Gear.  The analyses objects include both the files and information about the methods that were used to perform a specific (reproducible) analysis.