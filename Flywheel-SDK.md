The **scitran** client is designed to simplify using the Matlab version of the Flywheel SDK. The intention is to make it easier to find and use the Flywheel SDK methods.

There are cases in which you might just as well use the Flywheel SDK calls directly.  All of these calls are available to you in the scitran object.  When you create the scitran object the Flywheel SDK methods are available through the fw slot. 
You can see the full list of methods using tab-completion
 
    st = scitran('stanfordlabs')
    st.fw.<TAB>

We have a close relationship with the Flywheel SDK team, and in several cases functionality that we put in the wrapper migrated into the Flywheel SDK.  That's a good thing, though it does make extra programming for us.

## Related links

The Flywheel SDK documentation is growing.  Here is where things stand.

* [This api web page](https://flywheel-io.github.io/core/branches/master/matlab/flywheel.api.html) tersely describes the SDK methods. It also includes some chatty description and examples. 
* [This wiki web page](https://flywheel-io.github.io/core/) has the core documentation.

Here is a document tersely describing the [api calls](https://flywheel-io.github.io/core/branches/master/matlab/flywheel.api.html)

That wiki also has a large variety of [matlab examples](https://flywheel-io.github.io/core/branches/master/matlab/examples.html).
       
## Other programming languages

The Flywheel SDK is auto-generated and available for several languages (Matlab, Python, and R).  Here is the [wiki for all of the different languages](https://flywheel-io.github.io/core/)



