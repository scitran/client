We create a Matlab scitran object to interact with the database

    st = scitran(name, varargin)

The first time you run scitran for a site name, you will be queried for the site URL and the API Key.  This information will be stored on your computer for future reference.

The URL for the vistalab site is https://flywheel.scitran.stanford.edu.  You can find an API Key for your account on your site within the user profile tab on the user profile page.  

### An example

If you want to create a new instance, you can the name of the instance, as in

    st = scitran('newSite');

You will then be asked to enter your API key.  

    Please enter the API key: 

You can copy and paste from the API key entry in your user profile

![](https://github.com/scitran/client/wiki/images/userAPI.png)

You can verify that the new site has been added using the listInstances method

```
st.listInstances
     scitran: [1×1 struct]
         url: ''
       token: ''
    vistalab: [1×1 struct]
         cni: [1×1 struct]
     newSite: [1×1 struct]
```

### Usage examples 

If you already have the client configured, you can simply type

    st = scitran('vistalab');

To remove the site 

    st = scitran('vistalab','action','remove');

To refresh the API Key, obtain the new key on the site and then run

    st = scitran('vistalab','action','refresh');

### Verifying

You might use this code to verify that the scitran object is correctly connecting to the site

    % Should print the number of projects you have access
    st = scitran('vistalab','verify',true);   
    % Open the browser to verify that the URL and your ID are correct
    st.browser;

