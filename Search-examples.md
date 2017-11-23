

## Examples

There are many possible search parameters in `scitran.search()`. The script [s_stSearches.m](https://github.com/scitran/client/blob/master/scripts/s_stSearches.m) contains a series of more than 10 examples.  We describe some additional examples here, and you can find search used in many of the scitran scripts and examples.

To find all the projects with a particular label you can invoke

    project = st.search('projects','project label','VWFA');
    project = st.search('projects','project label contains','VWFA');



