* This page describes how to connect to the Flywheel site.
* The first time, you must provide a security key that is obtained from your Flywheel site
* [Flywheel manual - Getting started](https://flywheel-io.github.io/core/branches/master/matlab/getting_started.html)

***

### General use

A scitran client connection to the Flywheel site is established by creating a scitran Matlab object
```
st = scitran('stanfordlabs');
```

The scitran object (**st** in this case) contains the Flywheel database url, the instance name, a way to access the Flywheel SDK methods, and hidden information about user permission.
```
st = 

  scitran with properties:

         url: 'https://stanfordlabs.flywheel.io'
    instance: 'stanfordlabs'
          fw: [1×1 Flywheel]
```
### First use

The first time you run scitran to connect to a Flywheel site, you will be asked to authenticate yourself.  Specifically, you will have to provide the site URL and your API Key.  The API key is available from the Flywheel site web page.  To find your key

* Click on your user profile, which is found on the upper right of the Flywheel web page
* Scroll down to the API section (see image below)

The authentication key you enter will be stored on your computer - so this needs to be done infrequently. The API key expires after a few months, so you will need to enter it again to refresh your authentication every few months.

### An example

To create a connection to a newSite, type

    st = scitran('newSite');

You will be asked to enter your API key.  

    Please enter the API key: 

Copy and paste from API key in your user profile - it is the long string that looks like this:

![](https://github.com/scitran/client/wiki/images/userAPI.png)

### Examples 

If you already have the client configured, you can simply type

    st = scitran('newSite');

### List instances
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

### Remove instances

    st = scitran('newSite','action','remove');

To refresh the API Key, obtain the new key on the site and then run

    st = scitran('newSite','action','refresh');

### Verify the authentication

Use this method to verify that the scitran object is correctly connecting to your site

    % Should print the number of projects you have access
    st = scitran('newSite');   
    st.verify

    % Alternatively, you might choose to open the browser to verify that the URL 
    % and your ID are correct
    st.browser;

