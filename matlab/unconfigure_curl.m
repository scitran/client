function unconfigure_curl(curENV)
%% Reset library paths
if ismac
    setenv('DYLD_LIBRARY_PATH',curENV);
elseif (isunix && ~ismac)
    setenv('LD_LIBRARY_PATH',curENV);
else
    error('Unsupported system.\n');
end
return