## File storage
Scitran stores files using complex names designed for efficiency. Specifically, the file names reflect a complex computation based on their content.  Thus, when the same file is uploaded to the database, it has the same filename (content addressable data). This offers some striking efficiencies (no need to duplicate files).

## Database
Scitran's [MongoDB database](https://www.mongodb.org/) describes information about these files, and this is addressed through the MongoDB API.  

When humans want to interact with the files, we need understandable filenames and paths.  The scitran client uses [elastic search](http://joelabrahamsson.com/elasticsearch-101/) to find files and other database objects (sessions, projects, acquisitions, collections, analyses).  Hence, in this system we do not find files by leafing through directories and looking for files - the directories and filenames are not human-readable.  Rather we search for files.

There are other ways to humanize interactions with the files in a database. In an earlier implementation of the database, Bob Dougherty used the [Fuse filesystem](https://en.wikipedia.org/wiki/Filesystem_in_Userspace), a particularly useful tool for writing virtual file systems.  Historically, the method has [security issues](https://github.com/libfuse/libfuse/issues/15), and moreover we believe that search is central to our mission.  So, we converted to the elastic search approach.

## Metadata
ZL, LMP and BW screwed around to add a CG modality. 
they then created some custom fields for the modality classification.
This is how they did it.
```
%%
hierarchy = st.projectHierarchy('Graphics assets');
acquisitions = hierarchy.acquisitions;


cgClasses.model = {'Subaru','Mercedes','Ford','Volvo'};
modality = flywheel.model.Modality('id','CG','classification',cgClasses);
% First time
% st.fw.addModality(modality);
%
% Afterwards,
modalities = st.fw.getAllModalities;
% Find the one
id = modalities{2}.id;
st.fw.replaceModality(id,modality);


%%  How to set a file's classification
acquisitions = hierarchy.acquisitions{2};
thisAcquisition = acquisitions{1};
files = thisAcquisition.files{4};

% How do we adjust cInput?
% cInput = flywheel.model.ClassificationUpdateInput;
cInput = struct('modality','CG','classification',struct('asset','car'));
st.fw.modifyAcquisitionFile(thisAcquisition.id, files.name, struct('modality', 'CG'))
st.fw.setAcquisitionFileClassification(thisAcquisition.id, files.name, struct('asset',{{'car'}}))

%{
% We think this follows the logic.  Let's ask JE what we should do
%
st.fw.replaceAcquisitionFileClassification(thisAcquisition.id, files.name, struct('asset',{{'car'}}))
%}

% We would like to modify the acquisitionInfo also

```

