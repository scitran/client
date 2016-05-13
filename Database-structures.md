The database files are grouped logically into a set of basic categories that we define here.  The client search queries are structured around these categories.

* A **project** includes the data from multiple sessions; a project belongs to a research *group* 
* **Session** - What you might have done in an hour's session at the scanner, collecting a variety of data
* **Acquisitions** - groups of related files, such as the diffusion, bvecs and bval fall, or the dicom and nifti file, that are produced when you push the button on an MR scanner
* **Files** - single files, such as a nifti file, or a dicom file, ...
* **Collection** - users create collections from the Flywheel interface by combining multiple acquisitions or sessions.  Collections act as 'virtual experiments' in which the data collected at different projects, or by different groups, are combined and analyzed. Scitran creates these collections without duplicating the data
* **Analyses** - sets of files, within a collection or session, that have been analyzed using a Gear.  The analyses objects include both the files and information about the methods that were used to perform a specific (reproducible) analysis.