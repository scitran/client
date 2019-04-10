* The first time you use scitran, you must provide a security key that is obtained from your Flywheel site
* When you use scitran, you do **not** need to install the 'addons' toolbox as in the [Flywheel manual - Getting started](https://flywheel-io.github.io/core/branches/master/matlab/getting_started.html)

***

### First use

The first time you connect to a Flywheel site, you will be asked to authenticate.  The authentication is based on a secure API Key that you retrieve by logging into the Flywheel site.  To find your key

* Click on your user profile, which is found on the upper right of the Flywheel web page

![](https://github.com/scitran/client/wiki/images/loginProfile.png)

* Scroll down to the API section (see image below)

Copy the API key in your user profile - it is the long string that looks like this:

![](https://github.com/scitran/client/wiki/images/userAPI.png)

Now, back on your computer in the Matlab command prompt, create a connection to your instance (in this case **stanfordlabs**)

    st = scitran('stanfordlabs');

You will be asked to enter your API key.  Paste in the key, 

    Please enter the API key: 

The key will be stored on your computer. It expires after a few months, so you will need to enter it again to refresh your authentication from time to time.

### Verify the connection

To verify that the scitran object is connecting to your site, use the method
```
>> st.verify
Verified installed version 504
Verified connection

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
### General use

After your first use, the connection to a Flywheel instance is established by creating a scitran object and using the name of your Flywheel instance as argument to the scitran() function.
```
st = scitran('stanfordlabs');
```

The scitran object (**st** in this case) contains information about your Flywheel instance, access to the Flywheel SDK methods, and hidden information about your permissions.
```
st = 

  scitran with properties:

         url: 'https://stanfordlabs.flywheel.io'
    instance: 'stanfordlabs'
          fw: [1×1 Flywheel]
```

### Multiple instances
You can store the API key for multiple Flywheel instances.  To list the sites you have stored, use

    st.listInstances;

```
     scitran: [1×1 struct]
         url: ''
       token: ''
    vistalab: [1×1 struct]
         cni: [1×1 struct]
     newSite: [1×1 struct]
```
Remove an instance this way

    st = scitran('stanfordlabs','action','remove');

To refresh the API Key, use

    st = scitran('stanfordlabs','action','refresh');

and you will be prompted to enter the new key, which you can obtain from the Flywheel site as described in the 'First use' case, above.

