%% Read the T1 parameters
%
%

%%
st = scitran('stanfordlabs');

%%
project = st.lookup('wandell/Weston Havens');

%%

%{
project = st.fw.lookup('adni/ADNI: DWI (AD)');
project = st.fw.lookup('adni/ADNI: T1');
project = st.lookup('wandell/Weston Havens');
%}

% How do we find all the T1 nifti files in here?  A search?
fileList =  st.search('file','file type','dicom',...
    'project label exact','Brain Beats',...
    'acquisition label contains','T1w',...
    'summary', true);

% What we would like to do is search for all the files that have a
% classification of Measurement: {'T1'} and Intent: {'Structural'}

id = st.objectParse(fileList{1});
thisFile = st.list('file',fileList{1}.parent.id);
stSelect(thisFile,'type','nifti')
niftiFiles{1}.info


%%
st = scitran('stanfordlabs');

%% Working with DICOM files 

% First, the T1 measurement
%
% There appear to be a lot in the stanfordlabs instance. There are 5484
% on January 28, 2019.
% But a lot of them fail the stSearch2Container() call.
lmt = 1000;
badList = zeros(lmt,3);

fileList =  st.search('file','file type','dicom',...
    'measurement','T1',...
    'fw',false, ...
    'summary', true, ...
    'limit',lmt);
nFiles = length(fileList);
fprintf('Found %d T1 files\n',nFiles);
te = zeros(length(fileList),1);
ti = zeros(length(fileList),1);
tr = zeros(length(fileList),1);
fa = zeros(length(fileList),1);

for ii=1:length(fileList)
    % The ALDIT file ii = 80.  Something wrong.  Ask LMP.
    try
        thisFile = stSearch2Container(st,fileList{ii});
        te(ii) = thisFile.info.EchoTime;
        tr(ii) = thisFile.info.RepetitionTime;
        fa(ii) = thisFile.info.FlipAngle;
        try
            % Not sure why isfield() does not work.
            ti(ii) = thisFile.info.InversionTime;
        catch
            ti(ii) = NaN;
        end
    catch
        badList(ii,1) = 1;
        te(ii) = NaN;
        ti(ii) = NaN;
        tr(ii) = NaN;
        fa(ii) = NaN;
    end
    
end
fprintf('Number of bad T1 data files %d\n',sum(badList(:,1)));

%{
stNewGraphWin; histogram(te,50)
stNewGraphWin; histogram(ti,50)
stNewGraphWin; histogram(tr,50)
%}
%{
% Ask Adam Kerr about these TR values.
stNewGraphWin; stPlotJitter(ti,tr,[10 10],gcf);
grid on; xlabel('TI (ms)'); ylabel('TR (ms)');
%}

%{
stNewGraphWin; stPlotJitter(te,tr,[.04,30],gcf);
grid on; xlabel('TE (ms)'); ylabel('TR (ms)');
%}

%% T2

fileList =  st.search('file','file type','dicom',...
    'measurement','T2',...
    'fw',false, ...
    'summary', true, ...
    'limit',lmt);
nFiles = length(fileList);
fprintf('Found %d T2 files\n',nFiles);

% NO Inversion time expected for Diffusion,T2 data.
te2 = zeros(length(fileList),1);
tr2 = zeros(length(fileList),1);
fa2 = zeros(length(fileList),1);
ti2 = zeros(length(fileList),1);
for ii=1:length(fileList)
    try
        thisFile = stSearch2Container(st,fileList{ii});
        te2(ii) = thisFile.info.EchoTime;
        tr2(ii) = thisFile.info.RepetitionTime;
        fa2(ii) = thisFile.info.FlipAngle;
        if isfield(thisFile.info,'InversionTime')
            ti2(ii) = thisFile.info.InversionTime;
        else, ti2(ii) = NaN;
        end
    catch
        badList(ii,2) = 1;
        te2(ii) = NaN;
        fa2(ii) = NaN;
        tr2(ii) = NaN;
       
    end
end
%{
stNewGraphWin; histogram(te2,50)
stNewGraphWin; histogram(tr2,50)
stNewGraphWin; plot(te2(:),tr2(:),'o'); 
grid on; xlabel('TE'); ylabel('TR');
%}

%% Diffusion

fileList =  st.search('file','file type','dicom',...
    'measurement','Diffusion',...
    'fw',false, ...
    'summary', true, ...
    'limit',lmt);
nFiles = length(fileList);
fprintf('Found %d DWI files\n',nFiles);

% NO Inversion time expected for Diffusion,T2 data.
teD = zeros(nFiles,1);
trD = zeros(nFiles,1);
faD = zeros(nFiles,1);
tiD = zeros(nFiles,1);
for ii=1:nFiles
    try
        thisFile = stSearch2Container(st,fileList{ii});
        teD(ii) = thisFile.info.EchoTime;
        trD(ii) = thisFile.info.RepetitionTime;
        faD(ii) = thisFile.info.FlipAngle;
        if isfield(thisFile.info,'InversionTime')
              tiD(ii) = thisFile.info.InversionTime;
        else, tiD(ii) = NaN;
        end
    catch
        badList(ii,3) = 1;
        teD(ii) = NaN;
        faD(ii) = NaN;
        trD(ii) = NaN;
    end
end

%{
stNewGraphWin; histogram(teD,50)
stNewGraphWin; histogram(trD,50)
stNewGraphWin; plot(teD(:),trD(:),'o'); 
grid on; xlabel('TE'); ylabel('TR');
%}

%%  In the scatter plot, we can see the TR/TE differences
% The inversion time parameter only seems to be there for the T1, which
% makes sense in one way but ...


save('ParameterSummary','fa','te','tr','ti','fa2','te2','tr2','faD','teD','trD','fileList','badList');

%%

stNewGraphWin;
plot(te(:),tr(:),'bo',...
    te2(:),tr2(:),'go',...
    teD(:),trD(:),'ro');
grid on; xlabel('TE'); ylabel('TR');
legend({'T1','T2','Diffusion'})

% Make a 3D plot now

stNewGraphWin;
plot3(fa(:),te(:),tr(:),'bo'); hold on
plot3(fa2(:),te2(:),tr2(:),'go'); hold on
plot3(faD(:),teD(:),trD(:),'ro');
grid on; legend({'T1','T2','Diffusion'})
xlabel('FA'); ylabel('TE'); zlabel('TR');

%%

%%
fhdl = vcNewGraphWin;
stHistImage([trD(:),teD(:)],true,fhdl);
img2 = stHistImage([tr2(:),te2(:)],true,fhdl); colormap(parula)
mesh(img)

%%  Find all the scans that are intended to be structural
fileList =  st.search('file','file type','nifti',...
    'project label exact',project.label,...
    'intent','structural',...
    'fw',false, ...
    'summary', true);
%%

fileList =  st.search('file','file type','nifti',...
    'project label exact',project.label,...
    'intent','structural',...
    'measurement','T1',...
    'fw',false, ...
    'summary', true);

%%
project = st.lookup('wandell/VWFA FOV');

fileList =  st.search('file','file type','dicom',...
    'project label exact',project.label,...
    'intent','structural',...
    'measurement','T1',...
    'fw',true, ...
    'summary', true);

for ii=1:numel(fileList)
    try
        te(ii) = fileList{ii}.info.EchoTime;
    catch
        te(ii) = NaN;
    end
end
stNewGraphWin; histogram(te,100); xlabel('Echo Time (ms)');

%%

session  = project.sessions.findFirst();
session.acquisitions.findFirst();

%% Experiments with the CNI site

cni = scitran('cni');

%%
