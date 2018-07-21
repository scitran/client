The Matlab scitran client is a wrapper on the methods available in the Flywheel SDK. It is possible to use the SDK methods directly, without using the **scitran** methods. The value of **scitran** is that it reformulates the SDK methods in a way that we find easier to understand and use. 

Some day, the approach we have adopted here might be applied to the Flywheel SDK, in which case scitran will be less useful.  But for now, some people prefer to use scitran rather than calling the Flywheel SDK methods.  All of these methods are available from the scitran class (scitran.fw.<TAB>).

## Installing the SDK

We suggest you use the stFlywheelSDK command shown on the [Installation](Installation) page. That command downloads a matlab toolbox that is installed in the Add-Ons directory.

When you create the scitran object, st = scitran('stanfordlabs'); the Flywheel SDK methods are accessed 

     st.fw.<API-Commands>

Here is a document tersely describing the [api calls](https://flywheel-io.github.io/core/branches/master/matlab/flywheel.api.html)

That wiki also has a large variety of [matlab examples](https://flywheel-io.github.io/core/branches/master/matlab/examples.html).
       
The SDK is auto-generated and available for several languages (Matlab, Python, and R) as part of the Flywheel SDK.  Here is the [wiki for all of the different languages](https://flywheel-io.github.io/core/)

