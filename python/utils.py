from __future__ import print_function

import pandas as pd
import numpy as np

__author__ = 'vsitzmann'


def fulltext_df_search(key_value_pairs, dataframe):
    '''Does a fulltext search on the columns of the dataframe.


    Args:
        key_value_pairs (dict): python dictionary mapping potential column identifiers to the values they should match.
        dataframe (pandas dataframe): The pandas dataframe that shall be searched.

    Returns:
        numpy array: A boolean vector that can be used to index into the pandas dataframe.

    '''
    row_matches = np.ones(len(dataframe), dtype=bool)
    for key, value in key_value_pairs.iteritems():
        fitting_columns = [column for column in dataframe.columns if key in column]

        if len(fitting_columns)>1:
            print("The column identifier %s is not unique and matches the following column names: "%key, fitting_columns)
            print("Skipping this identifier for now. Please define a unique identifier.")
        else:
            row_matches = np.logical_and(row_matches, dataframe[fitting_columns[0]] == value)

    return row_matches
