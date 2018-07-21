The Matlab **scitran** client is a wrapper on the methods available in the Flywheel SDK. The **scitran** wrapper reformulates the SDK methods in a way that we find easier to understand and use. Over time, some of the principles in the wrapper might migrate into the Flywheel SDK; the Flywheel team will decide about that. 

We suggest you use the stFlywheelSDK command shown on the [Installation](Installation) page. That command downloads a matlab toolbox that is installed in the Add-Ons directory.

When you create the scitran object

    st = scitran('stanfordlabs')

the Flywheel SDK methods are available through the fw slot.  This enables you to use the SDK methods directly, or to write your own scitran methods calling the SDK methods. You can see the full list of methods by typing 

    st.fw.<TAB>

The list of SDK commands will show up as optional Matlab completions. 

## Related links

The Flywheel SDK documentation is growing.  Here is where things stand.

* [This api web page](https://flywheel-io.github.io/core/branches/master/matlab/flywheel.api.html) tersely describes the SDK methods. It also includes some chatty description and examples. 
* [This wiki web page](https://flywheel-io.github.io/core/) has the core documentation.

Here is a document tersely describing the [api calls](https://flywheel-io.github.io/core/branches/master/matlab/flywheel.api.html)

That wiki also has a large variety of [matlab examples](https://flywheel-io.github.io/core/branches/master/matlab/examples.html).
       
The SDK is auto-generated and available for several languages (Matlab, Python, and R) as part of the Flywheel SDK.  Here is the [wiki for all of the different languages](https://flywheel-io.github.io/core/)



