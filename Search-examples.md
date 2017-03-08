Using Matlab, the basic syntax for the search is to create a Matlab structure with specific fields that define the search parameters.

The first field defines the type of object you would like returned.  This is specified by the 'path' slot, as in

    % The value can be 
    %   'projects','sessions','acquisitions','files','collections', 'analyses', or 'subjects'
    srch.path = 'files';  

Additional fields define the conditions of the search.  Suppose that you want files that are within a collection whose label matches 'GearTest'.  Then you add this term to the Matlab srch structure.

    srch.collection.match.label = 'GearTest';

In general, search looks for any string matches.  So, if there is another collection called 'GearTest2', the search will return both 'GearTest' and 'GearTest2'.  If you want an exact match, then use

    srch.collection.match.exact_label = 'GearTest';

The set of terms you can match is defined by the [scitran data model](https://github.com/scitran/core/wiki/Data-Model). There are many possibilities, but for beginners (and we are all beginners) the key terms are probably illustrated here.

    srch.project.match.label = 'vwfa';
    srch.project.match.exact_label = 'vwfa';
    srch.session.match.name = '2016_05_10'
    srch.collections.match.label = 'ENGAGE';    
    srch.acquisitions.match.label = 'T1w 1mm'; 
    srch.files.match.type = 'bvec';

    srch.projects.bool.must(1).match.group = 'wandell';
    srch.projects.bool.must(2).match.label = 'vwfa';

    srch.sessions.bool.must{1}.range.subjectx0x2E_age.gt = year2sec(10);
    srch.sessions.bool.must{1}.range.subjectx0x2E_age.lt = year2sec(15);

The search 'operators' are 'match', 'bool', 'must', 'should' and 'range'.  For now, use the examples in the file [s_stSearches.m](https://github.com/scitran/client/blob/master/matlab/scripts/s_stSearches.m).  A more thorough document will appear.

### Syntax on searches

[Search syntax](Search syntax)

### Notes for Gear-heads

Matlab uses '.' in structs, and json allows '.' as part of the variable name. So, we insert a dot on the Matlab side by inserting a string, x0x2E_.  For example, to create a json object like this:

    s = {
   	"range": {
  		"subject.age": {
	   		  "lte": 315576000
		    }
	       }
      }

We use the code

     clear srch; 
     srch.range.subjectx0x2E_age.lte = years2sec(10);

(time values, including dates, are stored in SI units, seconds).

Another issue is the use of _ at the front of a variable, like _id

In this case, we cannot set a structure variable with a leading underscore, such as srch._id.  But we can set

     srch.projects.match.x0x5F_id = projectID;

The savejson('',srch) returns the variable as simply _id, without all the x0x5F nonsense.
