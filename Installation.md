## Github repositories
You must install this scitran repository and Guillaume Flandin's (JSONio). 

    git clone https://github.com/vistalab/scitran
    git clone https://github.com/gllmflndn/JSONio
    
Please add both directories to your path, say by using

    chdir(<scitran directory>); addpath(genpath(pwd));
    chdir(<JSONio directory>); addpath(genpath(pwd));

To verify the installation you can use
```
>> stFlywheelSDK('verify');
Verified installed version: 4.3.2
```

## Flywheel-SDK

### First connection

Or, you can connect to the Flywheel site and verify this way
```
>> st = scitran('stanfordlabs');
>> st.verify
Verified installed version: 4.3.2
Verified connection
```

