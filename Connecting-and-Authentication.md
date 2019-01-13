* The first time, you must provide a security key that is obtained from your Flywheel site
* [Flywheel manual - Getting started](https://flywheel-io.github.io/core/branches/master/matlab/getting_started.html)

***

### General use

A scitran client connection to the Flywheel site is established by creating a scitran object.
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

The first time you run scitran to connect to a Flywheel site, you will be asked to authenticate.  To do this, you will have to provide the site URL and your API Key.  The API key is available from the Flywheel site web page.  To find your key

* Click on your user profile, which is found on the upper right of the Flywheel web page

![](https://github.com/scitran/client/wiki/images/loginProfile.png)

* Scroll down to the API section (see image below)

The authentication key you enter will be stored on your computer - so this needs to be done infrequently. The API key expires after a few months, so you will need to enter it again to refresh your authentication every few months.

To create a connection to a **stanfordlabs**, type

    st = scitran('stanfordlabs');

You will be asked to enter your API key.  

    Please enter the API key: 

Copy and paste from API key in your user profile - it is the long string that looks like this:

![](https://github.com/scitran/client/wiki/images/userAPI.png)

### Verify the authentication

Use this method to verify that the scitran object is correctly connecting to your site
```
>> st.verify
Connection verified. SDK version 432

ans = 

  User with properties:

             id: 'wandell@stanford.edu'
      firstname: 'Brian'
       lastname: 'Wandell'
          email: 'wandell@stanford.edu'
         avatar: 'https://gravatar.com/avatar/eacf77651a3a7155eb0b66ddb9bf4588?s=512'
        avatars: [1×1 flywheel.model.Avatars]
           root: 1
       disabled: []
    preferences: []
         wechat: []
     firstlogin: '2016-03-16T23:05:28.246000+00:00'
      lastlogin: '2019-01-13T05:06:20.555000+00:00'
        created: 11-Mar-2016 23:14:59
       modified: 21-Dec-2018 23:23:59
         apiKey: [1×1 flywheel.model.UserApiKey]
```

### List and remove instances

If you already have the client configured, you can simply type

    st = scitran('stanfordlabs');

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

Or remove an instance this way

    st = scitran('stanfordlabs','action','remove');

To refresh the API Key, obtain the new key on the site and then run

    st = scitran('stanfordlabs','action','refresh');



