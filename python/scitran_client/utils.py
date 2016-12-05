from __future__ import print_function

import pandas as pd
import numpy as np
from copy import deepcopy

__author__ = 'vsitzmann'


def join_subject_acquisition_file_data(session_df, acquisition_df, file_df):
    '''Does an outer join of session, acquisiton and file dataframes to i.e. allow filtering files on subject metadata.

    Args:
        session_df (pandas DataFrame): A dataframe obtained by
            pandas.io.json.json_normalize(ScitranClient.search_sessions())
        acquisition_df (pandas DataFrame): A dataframe obtained by
            pandas.io.json.json_normalize(ScitranClient.search_acquisitions())
        file_df (pandas DataFrame): A dataframe obtained by
            pandas.io.json.json_normalize(ScitranClient.search_files())

    Returns:
        Pandas DataFrame joined to match acquisitions, files and sessions that belong together.
    '''
    sess_copy = deepcopy(session_df)
    acq_copy = deepcopy(acquisition_df)
    file_copy = deepcopy(file_df)

    sess_copy.columns = ['sess.'+column for column in session_df.columns]
    acq_copy.columns = ['acq.'+column for column in acquisition_df.columns]
    file_copy.columns = ['file.'+column for column in file_df.columns]

    sess_acq = sess_copy.merge(acq_copy, how='outer', left_on='sess._id', right_on='acq._source.session')
    sess_acq_files = sess_acq.merge(file_copy, how='outer', left_on='acq._id', right_on='file._source.container_id')

    print("These are the columns of the joined dataframe:")
    for column in sess_acq_files.columns:
        print(column)

    return sess_acq_files


def ft_column_search(column_identifier, dataframe):
    '''Does a fulltext search on the columns of the dataframe and returns A SINGLE COLUMN that matches.

    '''
    matching_columns = [column for column in dataframe.columns if column_identifier in column]

    if not matching_columns:
        print("No columns match the identifier %s" % column_identifier)
        return None
    elif len(matching_columns) > 1:
        print(
            "The column identifier %s is not unique and matches the following column names: " %
            column_identifier, matching_columns)
        return None
    else:
        print("\'%s\' identified column %s." % (column_identifier, matching_columns[0]))
        return matching_columns[0]


def fulltext_df_search(key_value_pairs, dataframe):
    '''Does a fulltext search on the dataframe columns using the keys, than returns the rows complying with the values.


    Args:
        key_value_pairs (dict): python dictionary mapping potential column identifiers to the values they should match.
        dataframe (pandas dataframe): The pandas dataframe that shall be searched.

    Returns:
        numpy array: A boolean vector that can be used to index into the pandas dataframe.

    '''
    overall_matches = np.ones(len(dataframe), dtype=bool)
    for key, value in key_value_pairs.iteritems():
        fitting_columns = [column for column in dataframe.columns if key in column]

        if not fitting_columns:
            print("No columns match the identifier %s" % key)
            return None
        elif len(fitting_columns) > 1:
            print(
                "The column identifier %s is not unique and matches the following column names: " %
                key, fitting_columns)
            print("Skipping this identifier for now. Please define a unique identifier.")
            return None
        else:
            key_value_hits = dataframe[fitting_columns[0]] == value
            overall_matches = np.logical_and(overall_matches, key_value_hits)
            print(
                "\'%s\' identified column %s. %d rows comply with the value %s." %
                (key, fitting_columns[0], len(np.where(key_value_hits)), value))

    print("Overall, %d rows comply with the search criteria" % (len(np.where(overall_matches))))
    return overall_matches


def get_search_result_df(search_results):
    if not search_results:
        # return None when there are no results because json_normalize crashes
        # with empty lists.
        return None
    return pd.io.json.json_normalize(search_results)
