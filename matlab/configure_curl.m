function curENV = configure_curl()
%% Configure library paths for curl command to work properly
% MAC
if ismac
    curENV = getenv('DYLD_LIBRARY_PATH');
    setenv('DYLD_LIBRARY_PATH','');
    
    % Linux
elseif (isunix && ~ismac)
    curENV = getenv('LD_LIBRARY_PATH');
    setenv('LD_LIBRARY_PATH','/usr/lib:/usr/local/lib');
    
    % Other/Unknown
else
    error('Unsupported system.\n');
end
return
