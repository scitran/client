### quickstart
looks a bit crazy, but it works!
```bash
pip install -e git+git@github.com:scitran/client.git#egg=scitran_client&subdirectory=python
```

Check out [this example](examples/fsl_bet.py) to see how to use it! you can run the example locally too
```bash
git clone git@github.com:scitran/client.git
cd client/python
virtualenv env
env/bin/pip install .
env/bin/python examples/fsl_bet.py
```

### ScitranClient API

Handles api calls to a certain instance.

Attributes:
    instance (str): instance name.
    base_url (str): The base url of that instance, as returned by stAuth.create_token(instance, st_dir)
    token (str): Authentication token.
    st_dir (str): The path to the directory where token and authentication file are kept for this instance.


#### download_file

Download a file that resides in a specified container.


Args:
    container_type (str): The type of container the file resides in (i.e. acquisition, session...)
    container_id (str): The elasticsearch id of the specific container the file resides in.
    dest_dir (str): Path to where the acquisition should be downloaded to.
    file_name (str): Name of the file.

Returns:
    string. The absolute file path to the downloaded acquisition.


#### download_all_file_search_results

Download all files contained in the list returned by a call to ScitranClient.search_files()

Args:
    file_search_results (dict): Search result.
    dest_dir (str): Path to the directory that files should be downloaded to.

Returns:
    string: Destination directory.


#### search

Searches given constraints (which supplies a path).

This is the most general function for an elastic search that allows to pass in a "path" as well as
a user-assembled list of constraints.

Args:
    constraints (dict): The constraints of the search, i.e.
        {'collections':{'should':[{'match':...}, ...]}, 'sessions':{'should':[{'match':...}, ...]}}

Returns:
    python dict of search results.


#### run_gear_and_upload_analysis

Runs a docker container on all files in an input directory and uploads input and output file in an analysis.

Args:
    metadata_label (str): The label of the uploaded analysis.
    container (str): The docker container to run.
    target_collection_id (str): The collection id of the target collection that analyses are uploaded to.
    in_dir (Optional[str]): The input directory to the gear where all the input files reside.
                                If not given, the self.gear_in_dir will be used.
    out_dir (Optional[str]): The output directory that should be used by the gear. If given, has to be empty.
                                If not given, the self.gear_out_dir will be used.

Returns:


### contributing
want to run changes to this code locally? it's pretty easy to get it added to an existing env. the `--upgrade` flag
ensures that your changes will get picked up.
```
pip install --upgrade $WORKSPACE/client/python
```
