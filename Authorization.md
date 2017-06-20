We create a Matlab scitran object to interact with the database

    st = scitran(name, varargin)

The first time you run scitran for a site name, you will be queried for the site URL and the API Key.  This information will be stored.

The URL for the vistalab site is https://flywheel.scitran.stanford.edu.  Your can find an API Key for your account on the user profile tab on the left of a Flywheel site.  For other scitran implementations (e.g., openNeuro.org), consult the site administrator.

### An example
```
st = scitran('vistalab','action','create')
Please enter the url (https://...): https://flywheel.scitran.stanford.edu
Please enter the API key: <long API Key obtained on the flywheel site>
API key saved for vistalab.
```

### scitran class 

If you already have the client configured, you can simply type

    st = scitran('vistalab');

To remove the site 

    st = scitran('vistalab','action','remove');

To refresh the API Key, obtain the new key on the site and then run

    st = scitran('vistalab','action','refresh');

To verify that the scitran object is correctly connecting to the site type

    st = scitran('vistalab','verify',true); st.browser;

