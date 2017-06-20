%% v_stJobSubmit
%
% DEPRECATE
%
% This validation script shows how to create a job from a search result and
% how to use the output of that job (provided you know something about it)
% as the input for another job.
%
%
% SciTran Team, 2016
%


%% Authorization & endpoint

st = scitran('scitran');
endpoint = 'api/jobs/add';


%% Drone secret

% This will soon be replaced by a token within the authorization header.

%%% DO NOT CHECK THIS IN %%%%
drone_secret = '';
%%% DO NOT CHECK THIS IN %%%%


%% SUBMIT A FSL-BET JOB on a T1

%% Find a T1 nifti file from adni using the acquisition description

clear srch
srch.path = 'files';

srch.collections.match.label   = 'ADNI T1';
srch.acquisitions.match.label  = 'T1_MR_MPRAGE';
srch.files.match.type          = 'nifti';

files = st.search(srch);


%% Define the job

% This will be the gear that is run
clear J
J.gear = 'fsl-bet';

% Define the inputs ( multiple inputs are defined by their type (dicom, nifti))
J.inputs.nifti.container_type = 'acquisition';
J.inputs.nifti.container_id = files{1}.source.container.x0x5F_id;
J.inputs.nifti.filename = files{1}.source.name;

% Define the destination (where to put the results from the gear)
J.destination.container_type = 'acquisition';
J.destination.container_id = files{1}.source.container.x0x5F_id;

% Define tags (optional)
J.tags = {'bet', 'analysis', 'brain-extraction', 'gear'};


%% Submit the JOB

job_body = savejson('',J);
submit_job_command = sprintf('curl -k -X POST %s/%s -d ''%s'' -H "X-SciTran-Auth:%s" -H "X-SciTran-Name:live.sh" -H "X-SciTran-Method:script" ', st.url, endpoint, job_body, drone_secret);

[~, jobID] = stCurlRun(submit_job_command);

disp(jobID);


%% SUBMIT ANOTHER JOB: This time on the outuput of the previous gear run

%% Execute a search to find the brain-extracted file

clear srch
srch.path = 'files';

% User the container_id from the previous search to find the right
% container
srch.acquisitions.match.x0x5F_id = J.inputs.nifti.container_id;
srch.files.match.name            = 'brain-extracted';

% Run the search 
files = st.search(srch);


%% Define the job 

clear J
J.gear = 'fsl-fast';

% Define inputs ( multiple inputs are defined by their type (dicom, nifti))
J.inputs.nifti.container_type = 'acquisition';
J.inputs.nifti.container_id = files{1}.source.container.x0x5F_id;
J.inputs.nifti.filename = files{1}.source.name;

% Define the destination (where to put the results from the gear)
J.destination.container_type = 'acquisition';
J.destination.container_id = files{1}.source.container.x0x5F_id;

% Define tags (optional)
J.tags = {'fast', 'analysis', 'segmentation', 'gear'};


%% Submit the JOB

job_body = savejson('',J);
submit_job_command = sprintf('curl -k -X POST %s/%s -d ''%s'' -H "X-SciTran-Auth:%s" -H "X-SciTran-Name:live.sh" -H "X-SciTran-Method:script" ', st.url, endpoint, job_body, drone_secret);

[~, jobID] = stCurlRun(submit_job_command);

disp(jobID);


%% Retrieve a JOB of a given type or with a certain tag:

% TODO - we await the ability to hit api/jobs/next with certain parameters to return specific jobs.


%% REFERENCE: 

% The JSON Job will look something like this:
% {
%     "gear": "dcm_convert",
%
%     "inputs": {
%         "dicom" : {
%             "container_type" : "acquisition",
%             "container_id" : "5728e3305598c0770609ab7e",
%             "filename" : "1_1_dicom.zip"
%         },
%         "also" : {
%             "container_type" : "acquisition",
%             "container_id" : "5728e3305598c0770609ab7e",
%             "filename" : "1_1_dicom.zip"
%         }
%     },
%
%     "tags": [
%         "manually-queued",
%         "fsl-bet"
%     ],
%
%     "destination": {
%         "container_type" : "acquisition",
%         "container_id" : "5728e3515598c0770609abb0"
%     }
% }
% http --verify=no POST https://docker.local.flywheel.io:8443/api/jobs/add @job-submit.json X-SciTran-Auth:change-me X-SciTran-Name:live.sh X-SciTran-Method:script
%
%
% J = loadjson('job-submit.json')
%

% Define second input in multi-file input job
% J.inputs.nifti.container_type = 'acquisition';
% J.inputs.nifti.container_id = '5728e3305598c0770609ab7e';
% J.inputs.nifti.filename = '1_1_dicom_nifti.nii.gz';

