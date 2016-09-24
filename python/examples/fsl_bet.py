from scitran_client import ScitranClient, query, Projects, Files, Acquisitions, Sessions
import os

client = ScitranClient('scitran')

# Sessions belong to projects. We can thus directly the 'label' field of 'projects'.
sessions = client.search(query(Sessions).filter(Projects.label.match('vwfa')))

# Files belong to acquisitions. We can filter files by their type (nifti, in this
# example), as well as by properties of their acquisitions.
files = client.search(query(Files).filter(
    Files.type.match('nifti'),
    # Acquisitions belong to sessions. We can make sure the acquisitions correspond
    # to a session we are interested in and make sure they have a useful type for us.
    Acquisitions.measurement.match('anatomy_t1w'),
    Acquisitions.session.in_(session['_id'] for session in sessions),
))

# Let's analyze the first file.
example_file = files[0]

# fsl-bet looks for files in the nifti subdirectory
nifti_dir = os.path.join(client.gear_in_dir, 'nifti')
if not os.path.exists(nifti_dir):
    os.mkdir(nifti_dir)
client.download_all_file_search_results([example_file], dest_dir=nifti_dir)

session_id = example_file['_source']['acquisition']['session']

# We let fsl-bet find the input file by having an empty string for a command.
client.run_gear_and_upload_analysis('testing fsl-bet local run', 'scitran/fsl-bet', session_id, '')
