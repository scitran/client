from __future__ import print_function
from builtins import input

import sys, os

sys.path.insert(1, os.path.join(sys.path[0], '..'))

from pprint import pprint
from elasticsearch_helper import *
import st_client
import pandas as pd
import utils
import settings

download_dir = settings.DEFAULT_DOWNLOADS_DIR
subject_code = 'PA27541'
scitran_dir = settings.AUTH_DIR

try:
    os.mkdir(download_dir)
except Exception:
    pass


def Filter_ADNIT1_subject_metadata():
    '''Retrieves files in the ADNI: T1 project that belong to subjects younger than 75 years.

    Returns:
        list of jsons describing files.
    '''
    # Create the scitran client instance, which handles all communication with the API.
    scitran_client = st_client.ScitranClient('scitran', debug=True)

    ###################################
    # Find the sessions in a project. #
    ###################################
    # Build a dictionary of constraints that describe the sessions we are looking for.
    session_constraints = {}
    # Sessions belong to projects. We can thus directly the 'label' field of 'projects'.
    session_constraints.update(constrain_element('projects', match('label', 'ADNI: T1')))
    # Not working yet - seems that it is not possible to directly constrain the subject.metadata.bAGE field.
    # session_constraints.update(constrain_element('sessions', range_from_to('subject.metadata.bAGE', from_value=0, to_value=75)))
    # run the search for sessions by passing the constraint dictionary to the scitran_client.search_sessions() function.
    relevant_sessions = scitran_client.search_sessions(session_constraints)
    # Convert the search result into a pandas dataframe for easier data analysis.
    sessions_df = utils.get_search_result_df(relevant_sessions)

    ###################################
    # Filter sessions by subject age. #
    ###################################
    # The pandas dataframe can be easily filtered. The logical expression on the right hand side returns an index vector.
    # We have to filter locally because the API does not yet allow to filter the 'subject' field.
    filtered_idcs = pd.to_numeric(sessions_df['_source.subject.metadata.bAGE']) < 75.0
    # Use that index vector to retrieve the relevant rows.
    filtered_sessions = sessions_df[filtered_idcs]

    session_ids = filtered_sessions['_id']
    print("Found %d sessions with subjects below the age of 75 in the ADNI: T1 project." % len(session_ids))

    ##################################
    # Find respective acquisitions.  #
    ##################################
    acq_constraints = {}
    acq_constraints.update(constrain_element('acquisitions',
                                             constant_score(
                                                 bool(
                                                     must(
                                                         match('measurement', 'anatomy_t1w'),
                                                     ),
                                                     should(
                                                         [match('session', session_id) for session_id in
                                                          session_ids]
                                                     ),
                                                     bool_minimum_should_match(1)
                                                 )
                                             )))
    relevant_acqs = scitran_client.search_acquisitions(acq_constraints)
    acqs_df = utils.get_search_result_df(relevant_acqs)

    #################################
    # Search respective files.      #
    #################################
    # Again, we assemble a dictionary of constraints.
    file_constraints = {}
    # We are searching for nifti files.
    file_constraints.update(constrain_element('files', match('type', 'nifti')))
    # The files we're looking for belong to acquisitions that in turn have to belong to the sessions we identified
    # earlier. Furthermore, we are looking only for anatomy acquisitions.

    # constant_score is necessary because, if a given acquisition only matches a single session_id in the session_id list,
    # this will improve its elasticsearch score only a tiny bit, not enough to boost it over the threshold. Constant_score
    # gives any search result that is even only slighty relevant a score of 1.0.
    file_constraints.update(constrain_element('acquisitions',
                                              constant_score(
                                                  bool(
                                                      must(
                                                          match('measurement', 'anatomy_t1w'),
                                                      ),
                                                      # The "should" query allows a list of possible session_ids.
                                                      should(
                                                          [match('session', session_id) for session_id in session_ids]
                                                      ),
                                                      # This is necessary to force a "boolean or"-like behaviour:
                                                      # An element must match AT LEAST ONE of the given session_ids.
                                                      bool_minimum_should_match(1)
                                                  ))))

    # Run the search by passing the constraints to the search_files function.
    relevant_files = scitran_client.search_files(file_constraints)
    files_df = utils.get_search_result_df(relevant_files)

    print("Found %d relevant files." % len(relevant_files))
    prompt_result = input("Download those files to %s (y/n)?" % download_dir)

    if prompt_result.lower() == 'y':
        # Download all files.
        scitran_client.download_all_file_search_results(relevant_files)

    joined_df = utils.join_subject_acquisition_file_data(session_df=sessions_df,
                                                         acquisition_df=acqs_df,
                                                         file_df=files_df)

    return joined_df


def ENGAGE_nifti_bval_bvec_diffusion_files():
    scitran_client = st_client.ScitranClient('scitran', debug=True)

    # Find the sessions in a project
    project_constraints = constrain_element('projects', match('label', 'ENGAGE'))
    relevant_sessions = scitran_client.search_sessions(project_constraints)
    sessions_df = pd.io.json.json_normalize(relevant_sessions)
    session_ids = sessions_df['_id'].tolist()
    print("Found %d sessions in the ENGAGE project." % len(session_ids))

    acq_constraints = {}
    acq_constraints.update(constrain_element('acquisitions',
                                             constant_score(
                                                 bool(
                                                     must(
                                                         match('measurement', 'diffusion'),
                                                     ),
                                                     should(
                                                         [match('session', session_id) for session_id in
                                                          session_ids]
                                                     ),
                                                     bool_minimum_should_match(1)
                                                 )
                                             )))
    relevant_acqs = scitran_client.search_acquisitions(acq_constraints)
    acqs_df = pd.io.json.json_normalize(relevant_acqs)

    file_constraints = {}
    file_constraints.update(constrain_element('files',
                                              constant_score(
                                                  bool(
                                                      should(
                                                          match('type', 'nifti'),
                                                          match('type', 'bvec'),
                                                          match('type', 'bval')
                                                      ),
                                                      bool_minimum_should_match(1)
                                                  )
                                              )))

    file_constraints.update(constrain_element('acquisitions',
                                              constant_score(
                                                  bool(
                                                      must(
                                                          match('measurement', 'diffusion'),
                                                      ),
                                                      should(
                                                          [match('session', session_id) for session_id in session_ids]
                                                      ),
                                                      bool_minimum_should_match(1)
                                                  ))))

    relevant_files = scitran_client.search_files(file_constraints)
    files_df = pd.io.json.json_normalize(relevant_files)
    print("Found %d relevant files." % len(relevant_files))
    prompt_result = input("Download those files to %s (y/n)?" % download_dir)
    print("\n")

    if prompt_result.lower() == 'y':
        scitran_client.download_all_file_search_results(relevant_files)

    joined_df = utils.join_subject_acquisition_file_data(session_df=sessions_df,
                                                         acquisition_df=acqs_df,
                                                         file_df=files_df)

    return joined_df


def ENGAGE_anatomy_acquisitions_niftis():
    scitran_client = st_client.ScitranClient('scitran', debug=True)

    # Find the sessions in a project
    project_constraints = constrain_element('projects', match('label', 'ENGAGE'))
    relevant_sessions = scitran_client.search_sessions(project_constraints)
    sessions_df = pd.io.json.json_normalize(relevant_sessions)
    session_ids = sessions_df['_id'].tolist()
    print("Found %d sessions in the ENGAGE project." % len(session_ids))

    acq_constraints = {}
    acq_constraints.update(constrain_element('acquisitions',
                                             constant_score(
                                                 bool(
                                                     must(
                                                         match('measurement', 'anatomy'),
                                                     ),
                                                     should(
                                                         [match('session', session_id) for session_id in
                                                          session_ids]
                                                     ),
                                                     bool_minimum_should_match(1)
                                                 )
                                             )))
    relevant_acqs = scitran_client.search_acquisitions(acq_constraints)
    acqs_df = pd.io.json.json_normalize(relevant_acqs)

    file_constraints = {}
    file_constraints.update(constrain_element('files', match('type', 'nifti')))
    file_constraints.update(constrain_element('acquisitions',
                                              constant_score(
                                                  bool(
                                                      must(
                                                          match('measurement', 'anatomy'),
                                                      ),
                                                      should(
                                                          [match('session', session_id) for session_id in session_ids]
                                                      )
                                                  ))))

    relevant_files = scitran_client.search_files(file_constraints)
    file_df = pd.io.json.json_normalize(relevant_files)

    print("Found %d relevant files." % len(relevant_files))
    prompt_result = input("Download those files to %s (y/n)?" % download_dir)

    if prompt_result.lower() == 'y':
        scitran_client.download_all_file_search_results(relevant_files)

    joined_df = utils.join_subject_acquisition_file_data(session_df=sessions_df,
                                                         acquisition_df=acqs_df,
                                                         file_df=file_df)

    return joined_df


def qa_reports_functional_acqs_females():
    # TODO (vsitzmann): request is too large?
    # How is this filetype called?
    scitran_client = st_client.ScitranClient('scitran', debug=True)

    file_constraints = {}
    file_constraints.update(constrain_element('files', match('name', 'qa_report.png')))
    file_constraints.update(constrain_element('acquisitions',
                                              constant_score(
                                                  bool(
                                                      must(
                                                          match('measurement', 'functional'),
                                                      )
                                                  ))))

    relevant_files = scitran_client.search_files(file_constraints)
    files_df = utils.get_search_result_df(relevant_files)

    relevant_acq_ids = files_df[utils.ft_column_search('container_id', files_df)].tolist()

    acq_constraints = {}
    acq_constraints.update(constrain_element('acquisitions',
                                             constant_score(
                                                 bool(
                                                     should(
                                                         [match('_id', acq_id) for acq_id in relevant_acq_ids]
                                                     )
                                                 )
                                             )))
    relevant_acqs = scitran_client.search_acquisitions(acq_constraints)
    acqs_df = utils.get_search_result_df(relevant_acqs)

    relevant_session_ids = acqs_df[utils.ft_column_search('session', acqs_df)].tolist()

    session_constraints = {}
    session_constraints.update(constrain_element('sessions',
                                                 constant_score(
                                                     bool(
                                                         should(
                                                             [match('id', sess_id) for sess_id in relevant_session_ids]
                                                         )
                                                     )
                                                 )))
    relevant_sessions = scitran_client.search_sessions(session_constraints)
    sessions_df = utils.get_search_result_df(relevant_sessions)

    joined_df = utils.join_subject_acquisition_file_data(session_df=sessions_df,
                                                         acquisition_df=acqs_df,
                                                         file_df=files_df)

    prompt_result = input("Download those files to %s (y/n)?" % download_dir)

    if prompt_result.lower() == 'y':
        scitran_client.download_all_file_search_results(relevant_files)

    return joined_df
