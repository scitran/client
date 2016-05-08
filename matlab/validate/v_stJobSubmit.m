%% v_stJobSubmit
%
% Add a single or multi-file job to a scitran db.
%
% The Job will look something like this:
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
%         "live.sh"
%     ],
%
%     "destination": {
%         "container_type" : "acquisition",
%         "container_id" : "5728e3515598c0770609abb0"
%     }
% }
% http --verify=no POST https://docker.local.flywheel.io:8443/api/jobs/add @~/Desktop/job-submit.json X-SciTran-Auth:change-me X-SciTran-Name:live.sh X-SciTran-Method:script
%
%
% J = loadjson('~/Desktop/job-submit.json')
%
%
% SciTran Team, 2016
%


%% Authorization

[token, url] = stAuth('instance', 'local');


%% Define the job

% This will be the gear that is run
J.gear = 'dcm_convert';

% Define inputs ( multiple inputs are defined by their type (dicom, nifti))
J.inputs.dicom.container_type = 'acquisition';
J.inputs.dicom.container_id = '5728e3305598c0770609ab7e';
J.inputs.dicom.filename = '1_1_dicom.zip';

% Define second input in multi-file input job
% J.inputs.nifti.container_type = 'acquisition';
% J.inputs.nifti.container_id = '5728e3305598c0770609ab7e';
% J.inputs.nifti.filename = '1_1_dicom_nifti.nii.gz';

% Define the destination (where to put the results from the 'output' dir of the container)
J.destination.container_type = 'acquisition';
J.destination.container_id = '5728e3305598c0770609ab7e';

% Define tags (optional)
J.tags = {'dicom', 'converter', 'dcm_convert'};


%% Submit the JOB

endpoint = 'api/jobs/add';
job_body = savejson('',J);

submit_job_command = sprintf('curl -k -X POST %s/%s -d ''%s'' -H "Authorization":"%s" -H "X-SciTran-Name:live.sh" -H "X-SciTran-Method:script" ', url, endpoint, job_body, token);

[s, jobID] = stCurlRun(submit_job_command);

disp(jobID);


%% Retrieve a JOB of a given type or with a certain tag:

% TODO - we await the ability to hit api/jobs/next with certain parameters to return specific jobs.

