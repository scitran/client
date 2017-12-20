We create a Matlab scitran object to interact with the database

    st = scitran(name, varargin)

The first time you run scitran for a site name, you will be queried for the site URL and the API Key.  This information will be stored on your computer for future reference.

### An example

If you want to create a new instance, you can the name of the instance, as in

    st = scitran('newSite');

You will then be asked to enter your API key.  

    Please enter the API key: 

Copy and paste from API key in your user profile - it is the long string that looks like this:

![](https://github.com/scitran/client/wiki/images/userAPI.png)



### Usage examples 

If you already have the client configured, you can simply type

    st = scitran('vistalab');

To list the sites you have stored, you can type

    st.listInstances;

```
     scitran: [1×1 struct]
         url: ''
       token: ''
    vistalab: [1×1 struct]
         cni: [1×1 struct]
     newSite: [1×1 struct]
```
To remove a site 

    st = scitran('vistalab','action','remove');

To refresh the API Key, obtain the new key on the site and then run

    st = scitran('vistalab','action','refresh');

### Verifying

Use this method to verify that the scitran object is correctly connecting to your site

    % Should print the number of projects you have access
    st = scitran('vistalab');   
    st.verify

    % Alternatively, you might choose to open the browser to verify that the URL 
    % and your ID are correct
    st.browser;

